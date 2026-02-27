# app/models/eventospersona.rb
class Eventospersona < ApplicationRecord
  belongs_to :evento
  belongs_to :estado_civil
  belongs_to :documento_tipo, optional: true
  belongs_to :persona, optional: true
  belongs_to :acudiente, class_name: 'Persona', optional: true

  # Solo archivos virtuales — acudiente_documento_tipo_id ya es columna real
  attr_accessor :cedula_frente, :cedula_reverso,
                :acudiente_cedula_frente, :acudiente_cedula_reverso

  TIPOS_PERSONA = ['CASADO', 'SEMINARISTA', 'SOLTERO'].freeze

  # Validaciones generales
  validates :identificacion, :nombre, :apellido, :fecha_nacimiento,
            :direccion, :celular, :email, :sexo, :tipo_persona,
            presence: { message: "es obligatorio" }

  validates :estado_civil_id,   presence: { message: "es obligatorio" }
  validates :documento_tipo_id, presence: { message: "es obligatorio" }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" }

  validates :celular,        length: { maximum: 20, message: "no puede tener más de 20 caracteres" }
  validates :identificacion, length: { maximum: 20, message: "no puede tener más de 20 caracteres" }

  validates :tipo_persona, inclusion: {
    in: TIPOS_PERSONA,
    message: "debe ser CASADO, SEMINARISTA o SOLTERO"
  }

  validates :acepta_politica,
            acceptance: { accept: 'SI', message: 'Debes aceptar las políticas de tratamiento de datos personales' },
            presence:   { message: 'Debes aceptar las políticas de tratamiento de datos personales' }

  validates :acepta_cultura,
            acceptance: { accept: 'SI', message: 'Debes aceptar la cultura organizacional' },
            presence:   { message: 'Debes aceptar la cultura organizacional' }

  validates :identificacion, uniqueness: {
    scope: :evento_id,
    message: "ya está registrado para este evento"
  }

  # Validar documentos obligatorios
  validate :documentos_obligatorios

  # Validaciones condicionales para menores de edad
  validates :acudiente_nombre, :acudiente_apellido, :acudiente_identificacion,
            :acudiente_celular, :acudiente_email,
            presence: { message: "es obligatorio para menores de edad" },
            if: :menor_de_edad?

  validates :acudiente_documento_tipo_id,
            presence: { message: "es obligatorio para menores de edad" },
            if: :menor_de_edad?

  validates :acudiente_email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" },
            if: :menor_de_edad?

  validate :validar_cupos_disponibles

  # Callbacks
  before_validation :asegurar_aceptaciones  # <-- FALTABA
  before_save :normalizar_datos
  before_save :buscar_o_crear_persona
  after_save  :guardar_documentos_todos

  # -------------------------------------------------------

  def menor_de_edad?
    return false if fecha_nacimiento.blank?
    calcular_edad < 18
  end

  def calcular_edad
    return 0 if fecha_nacimiento.blank?
    hoy = Date.current
    edad = hoy.year - fecha_nacimiento.year
    edad -= 1 if hoy < fecha_nacimiento + edad.years
    edad
  end

  def validar_cupos_disponibles
    return unless evento
    errors.add(:base, "El evento ya alcanzó el número máximo de participantes") if evento.lleno?
  end

  def documentos_obligatorios
    # Solo valida en registros nuevos (no en actualizaciones)
    return unless new_record?

    if cedula_frente.blank?
      errors.add(:cedula_frente, "es obligatorio cargar la foto del documento frente")
    end
    if cedula_reverso.blank?
      errors.add(:cedula_reverso, "es obligatorio cargar la foto del documento reverso")
    end

    if menor_de_edad?
      if acudiente_cedula_frente.blank?
        errors.add(:acudiente_cedula_frente, "es obligatorio cargar el documento del acudiente frente")
      end
      if acudiente_cedula_reverso.blank?
        errors.add(:acudiente_cedula_reverso, "es obligatorio cargar el documento del acudiente reverso")
      end
    end
  end

  private

  def buscar_o_crear_persona
    persona = Persona.find_or_initialize_by(identificacion: self.identificacion)
    persona.nombre            = self.nombre
    persona.apellido          = self.apellido
    persona.fecha_nacimiento  = self.fecha_nacimiento
    persona.direccion         = self.direccion
    persona.celular           = self.celular
    persona.email             = self.email
    persona.sexo              = self.sexo
    persona.estado_civil_id   = self.estado_civil_id
    persona.documento_tipo_id = self.documento_tipo_id

    if persona.save
      self.persona_id = persona.id
    else
      Rails.logger.warn "⚠️ No se pudo guardar Persona: #{persona.errors.full_messages}"
    end

    if menor_de_edad? && acudiente_identificacion.present?
      acudiente = Persona.find_or_initialize_by(identificacion: self.acudiente_identificacion)
      acudiente.nombre            = self.acudiente_nombre
      acudiente.apellido          = self.acudiente_apellido
      acudiente.celular           = self.acudiente_celular
      acudiente.email             = self.acudiente_email
      acudiente.documento_tipo_id = self.acudiente_documento_tipo_id
      acudiente.estado_civil_id   = acudiente.estado_civil_id.presence || 1

      if acudiente.save
        self.acudiente_id = acudiente.id
      else
        Rails.logger.warn "⚠️ No se pudo guardar Acudiente: #{acudiente.errors.full_messages}"
      end
    end
  end

  def guardar_documentos_todos
    guardar_documentos(self.persona)             if self.persona_id.present?
    guardar_documentos_acudiente(self.acudiente) if menor_de_edad? && self.acudiente_id.present?
  end

  def guardar_documentos(persona)
    return if cedula_frente.blank? && cedula_reverso.blank?
    documento = Documento.find_or_initialize_by(
      persona_id:        persona.id,
      tipo_documento_id: self.documento_tipo_id || 1
    )
    documento.eventospersona_id = self.id
    documento.cedula_frente     = cedula_frente  if cedula_frente.present?
    documento.cedula_reverso    = cedula_reverso if cedula_reverso.present?
    documento.save || Rails.logger.warn("⚠️ Documento: #{documento.errors.full_messages}")
  end

  def guardar_documentos_acudiente(acudiente)
    return if acudiente_cedula_frente.blank? && acudiente_cedula_reverso.blank?
    documento = Documento.find_or_initialize_by(
      persona_id:        acudiente.id,
      tipo_documento_id: self.acudiente_documento_tipo_id || 1
    )
    documento.eventospersona_id = self.id
    documento.cedula_frente     = acudiente_cedula_frente  if acudiente_cedula_frente.present?
    documento.cedula_reverso    = acudiente_cedula_reverso if acudiente_cedula_reverso.present?
    documento.save || Rails.logger.warn("⚠️ Documento Acudiente: #{documento.errors.full_messages}")
  end

  def normalizar_datos
    self.nombre    = nombre.upcase if nombre.present?
    self.apellido  = apellido.upcase if apellido.present?
    self.direccion = direccion.upcase if direccion.present?
    self.acudiente_nombre   = acudiente_nombre.upcase if acudiente_nombre.present?
    self.acudiente_apellido = acudiente_apellido.upcase if acudiente_apellido.present?
  end

  def asegurar_aceptaciones
    self.acepta_politica = "NO" if acepta_politica.blank?
    self.acepta_cultura  = "NO" if acepta_cultura.blank?
  end
end