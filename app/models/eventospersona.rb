# app/models/eventospersona.rb
class Eventospersona < ApplicationRecord
  belongs_to :evento
  belongs_to :estado_civil
  belongs_to :documento_tipo, optional: true
  belongs_to :persona, optional: true
  belongs_to :acudiente, class_name: 'Persona', optional: true

  # Atributos virtuales para las imágenes capturadas con la cámara.
  # El controlador los asigna ANTES de llamar a save, para que pasen
  # las validaciones. El guardado real en Documento lo hace el controlador
  # después del save.
  attr_accessor :cedula_frente, :cedula_reverso,
                :acudiente_cedula_frente, :acudiente_cedula_reverso

  # Si la persona ya tiene documentos registrados, el controlador pone
  # este flag en true para saltarse la validación de fotos obligatorias.
  attr_accessor :ya_tiene_documentos, :persona_ya_tiene_documentos

  TIPOS_PERSONA = ['CASADO', 'SEMINARISTA', 'SOLTERO'].freeze

  # ── Validaciones generales ────────────────────────────────────────────────
  validates :identificacion, :nombre, :apellido, :fecha_nacimiento,
            :direccion, :celular, :email, :sexo, :tipo_persona,
            presence: { message: "es obligatorio" }

  validates :estado_civil_id,   presence: { message: "es obligatorio" }
  validates :documento_tipo_id, presence: { message: "es obligatorio" }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" }

  validates :celular,        length: { maximum: 20 }
  validates :identificacion, length: { maximum: 20 }

  validates :tipo_persona, inclusion: { in: TIPOS_PERSONA,
                                        message: "debe ser CASADO, SEMINARISTA o SOLTERO" }

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

  # ── Validaciones condicionales (menores de edad) ──────────────────────────
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

  # ── Validaciones custom ───────────────────────────────────────────────────
  validate :documentos_obligatorios
  validate :validar_cupos_disponibles

  # ── Callbacks ─────────────────────────────────────────────────────────────
  before_validation :asegurar_aceptaciones
  before_save       :normalizar_datos
  before_save       :buscar_o_crear_persona
  # ↓ ELIMINADO: after_save :guardar_documentos_todos
  #   El controlador se encarga de guardar los Documentos después del save,
  #   porque en ese momento ya tiene los UploadedFile listos (base64_a_paperclip).

  # ── Helpers públicos ──────────────────────────────────────────────────────

  def menor_de_edad?
    return false if fecha_nacimiento.blank?
    calcular_edad < 18
  end

  def calcular_edad
    return 0 if fecha_nacimiento.blank?
    hoy  = Date.current
    edad = hoy.year - fecha_nacimiento.year
    edad -= 1 if hoy < fecha_nacimiento + edad.years
    edad
  end

  private

  # ── Validación: documentos obligatorios ───────────────────────────────────
  # Acepta tanto un ActionDispatch::Http::UploadedFile (cámara/base64)
  # como cualquier objeto presente (por si en el futuro se vuelve a input file).
  def documentos_obligatorios
    return unless new_record?
    # Si la persona ya tiene documentos guardados (detectado en el controlador
    # al hacer autocomplete), no exigimos captura nueva.
    return if ya_tiene_documentos || persona_ya_tiene_documentos == "1"

    errors.add(:cedula_frente,  "es obligatorio capturar la foto del documento frente")  if cedula_frente.blank?
    errors.add(:cedula_reverso, "es obligatorio capturar la foto del documento reverso") if cedula_reverso.blank?

    if menor_de_edad?
      errors.add(:acudiente_cedula_frente,  "es obligatorio capturar el documento del acudiente frente")  if acudiente_cedula_frente.blank?
      errors.add(:acudiente_cedula_reverso, "es obligatorio capturar el documento del acudiente reverso") if acudiente_cedula_reverso.blank?
    end
  end

  def validar_cupos_disponibles
    return unless evento
    errors.add(:base, "El evento ya alcanzó el número máximo de participantes") if evento.lleno?
  end

  # ── Normalizar texto a mayúsculas ─────────────────────────────────────────
  def normalizar_datos
    self.nombre    = nombre.upcase    if nombre.present?
    self.apellido  = apellido.upcase  if apellido.present?
    self.direccion = direccion.upcase if direccion.present?
    self.acudiente_nombre   = acudiente_nombre.upcase   if acudiente_nombre.present?
    self.acudiente_apellido = acudiente_apellido.upcase if acudiente_apellido.present?
  end

  # ── Garantizar valores por defecto en aceptaciones ───────────────────────
  def asegurar_aceptaciones
    self.acepta_politica = "NO" if acepta_politica.blank?
    self.acepta_cultura  = "NO" if acepta_cultura.blank?
  end

  # ── Buscar o crear Persona y Acudiente en tabla personas ─────────────────
  def buscar_o_crear_persona
    persona = Persona.find_or_initialize_by(identificacion: self.identificacion)
    persona.assign_attributes(
      nombre:            nombre,
      apellido:          apellido,
      fecha_nacimiento:  fecha_nacimiento,
      direccion:         direccion,
      celular:           celular,
      email:             email,
      sexo:              sexo,
      estado_civil_id:   estado_civil_id,
      documento_tipo_id: documento_tipo_id
    )

    if persona.save
      self.persona_id = persona.id
    else
      Rails.logger.warn "⚠️ No se pudo guardar Persona: #{persona.errors.full_messages}"
    end

    # Acudiente (solo menores de edad)
    if menor_de_edad? && acudiente_identificacion.present?
      acudiente = Persona.find_or_initialize_by(identificacion: acudiente_identificacion)
      acudiente.assign_attributes(
        nombre:            acudiente_nombre,
        apellido:          acudiente_apellido,
        celular:           acudiente_celular,
        email:             acudiente_email,
        documento_tipo_id: acudiente_documento_tipo_id,
        estado_civil_id:   acudiente.estado_civil_id.presence || 1
      )

      if acudiente.save
        self.acudiente_id = acudiente.id
      else
        Rails.logger.warn "⚠️ No se pudo guardar Acudiente: #{acudiente.errors.full_messages}"
      end
    end
  end
end