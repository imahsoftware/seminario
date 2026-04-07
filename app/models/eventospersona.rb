# app/models/eventospersona.rb
class Eventospersona < ApplicationRecord
  belongs_to :evento
  belongs_to :estado_civil
  belongs_to :documento_tipo, optional: true
  belongs_to :persona, optional: true
  belongs_to :acudiente, class_name: 'Persona', optional: true
  belongs_to :acudiente_documento_tipo, class_name: 'DocumentoTipo',
             foreign_key: 'acudiente_documento_tipo_id',
             optional: true

  # ── Adjuntos Paperclip (se asignan en el controller) ─────────────────────
  attr_accessor :cedula_frente, :cedula_reverso,
                :acudiente_cedula_frente, :acudiente_cedula_reverso

  # ── Campos base64 que llegan desde el formulario HTML ────────────────────
  attr_accessor :cedula_frente_base64, :cedula_reverso_base64,
                :acudiente_cedula_frente_base64, :acudiente_cedula_reverso_base64

  # ── Flags de documentos existentes ───────────────────────────────────────
  attr_accessor :ya_tiene_documentos, :persona_ya_tiene_documentos,
                :acudiente_ya_tiene_documentos

  TIPOS_PERSONA = ['MATRIMONIO', 'SEMINARISTA', 'HOMBRE SOLO','MUJER SOLA','PRESBÍTERO'].freeze

  # ── Validaciones generales ────────────────────────────────────────────────
  validates :identificacion, :nombre, :apellido, :fecha_nacimiento,
            :direccion, :celular, :email, :sexo, :tipo_persona,
            presence: { message: "es obligatorio" }

  validates :documento_tipo_id, presence: { message: "es obligatorio" }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" }

  validates :celular,        length: { maximum: 20 }
  validates :identificacion, length: { maximum: 20 }

  validates :tipo_persona, inclusion: { in: TIPOS_PERSONA,
                                        message: "debe ser MATRIMONIO, SEMINARISTA, HOMBRE SOLO,MUJER SOLA,PRESBÍTERO" }

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
  # Nota: acudiente_documento_tipo_id ya NO se valida aquí.
  # El acudiente sube su documento en la vista de autorización (después del registro).
  validates :acudiente_nombre, :acudiente_apellido, :acudiente_identificacion,
            :acudiente_celular, :acudiente_email,
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
  before_validation :parsear_fecha_nacimiento
  before_save       :normalizar_datos
  before_save       :buscar_o_crear_persona

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

  # Al final de los callbacks existentes, agregar:
  after_create  :crear_usuario_inscrito
  before_destroy :auditar_eliminacion

  attr_accessor :eliminado_por

  # ── Crear usuario automáticamente al inscribirse ──────────────────────────
  def crear_usuario_inscrito
    return if identificacion.blank?
    return if User.exists?(identificacion: identificacion)   # ya tiene cuenta

    email_usuario = email.presence || "#{identificacion}@evento.local"

    user = User.new(
      email:          email_usuario,
      username:       identificacion,
      identificacion: identificacion,
      nombres:        nombre,
      apellidos:      apellido,
      nombre:         "#{nombre} #{apellido}",
      nombre_real:    "#{nombre} #{apellido}",
      celular:        celular,
      tipoconsulta:   'INSCRITO',
      activo:         'S',
      estado:         'A',
      persona_id:     persona_id,
      password:       identificacion,
      password_confirmation: identificacion
    )

    if user.save
      Rails.logger.info "✅ Usuario INSCRITO creado para identificacion: #{identificacion}"
    else
      Rails.logger.warn "⚠️ No se pudo crear usuario para #{identificacion}: #{user.errors.full_messages}"
    end
  end

  # ── Auditar eliminación ────────────────────────────────────────────────────
  def auditar_eliminacion
    Eventoseliminado.create!(
      evento_id:             evento_id,
      eventospersona_id:     id,
      identificacion:        identificacion,
      nombre:                nombre,
      apellido:              apellido,
      email:                 email,
      celular:               celular,
      tipo_persona:          tipo_persona,
      fecha_nacimiento:      fecha_nacimiento,
      eliminado_por_user_id: eliminado_por&.id,
      eliminado_por_nombre:  eliminado_por&.nombre,
      datos_completos:       self.attributes.to_json
    )
  end

  private

  # ── Validación: documentos obligatorios del TITULAR ──────────────────────
  # Los documentos del acudiente se capturan en la vista de autorización,
  # por eso NO se validan aquí.
  def documentos_obligatorios
    return unless new_record?

    titular_tiene_docs = ya_tiene_documentos || persona_ya_tiene_documentos == "1"
    unless titular_tiene_docs
      errors.add(:cedula_frente,  "es obligatorio capturar la foto del documento frente")  if cedula_frente.blank?
      errors.add(:cedula_reverso, "es obligatorio capturar la foto del documento reverso") if cedula_reverso.blank?
    end
  end

  def validar_cupos_disponibles
    return unless evento
    errors.add(:base, "El evento ya alcanzó el número máximo de participantes") if evento.lleno?
  end

  # ── Parsear fecha_nacimiento desde string DD/MM/YYYY ─────────────────────
  def parsear_fecha_nacimiento
    return if fecha_nacimiento.blank? || fecha_nacimiento.is_a?(Date)

    fecha_str = fecha_nacimiento.to_s.strip.gsub('-', '/')
    return unless fecha_str =~ /\A(\d{1,2})\/(\d{1,2})\/(\d{4})\z/

    d, m, y = $1.to_i, $2.to_i, $3.to_i

    self.fecha_nacimiento = if m > 12
                              Date.new(y, d, m) rescue nil  # MM/DD/YYYY → invertir
                            else
                              Date.new(y, m, d) rescue nil  # DD/MM/YYYY → normal
                            end
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
    # ── Titular ────────────────────────────────────────────────────────────
    persona = Persona.find_or_initialize_by(identificacion: self.identificacion)
    persona.assign_attributes(
      nombre:            nombre,
      apellido:          apellido,
      fecha_nacimiento:  fecha_nacimiento,
      direccion:         direccion,
      celular:           celular,
      email:             email,
      sexo:              sexo,
      documento_tipo_id: documento_tipo_id,
      estado_civil_id:   6,

      )

    if persona.save
      self.persona_id = persona.id
    else
      Rails.logger.warn "⚠️ No se pudo guardar Persona: #{persona.errors.full_messages}"
    end

    # ── Acudiente (solo menores) ────────────────────────────────────────────
    return unless menor_de_edad? && acudiente_identificacion.present?

    acudiente = Persona.find_or_initialize_by(identificacion: acudiente_identificacion)
    acudiente.assign_attributes(
      nombre:            acudiente_nombre,
      apellido:          acudiente_apellido,
      celular:           acudiente_celular,
      email:             acudiente_email,
      # documento_tipo_id se actualizará cuando el acudiente suba su doc en autorización.
      # Se usa el valor existente si ya tiene uno, o 1 como fallback para no romper el NOT NULL.
      documento_tipo_id: acudiente_documento_tipo_id.presence || acudiente.documento_tipo_id.presence || 1,
      estado_civil_id:   acudiente.estado_civil_id.presence || 1

    )

    if acudiente.save
      self.acudiente_id = acudiente.id
    else
      Rails.logger.warn "⚠️ No se pudo guardar Acudiente: #{acudiente.errors.full_messages}"
    end
  end
end
