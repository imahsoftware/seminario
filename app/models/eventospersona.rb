# app/models/eventospersona.rb
class Eventospersona < ApplicationRecord
  belongs_to :evento
  belongs_to :persona
  belongs_to :acudiente, class_name: 'Persona', optional: true
  accepts_nested_attributes_for :persona  # <-- Esto permite crear la persona desde eventospersona

  # Constantes
  TIPOS_PERSONA = ['CASADO', 'SEMINARISTA', 'SOLTERO'].freeze

  # Validaciones de campos obligatorios
  validates :identificacion, :nombre, :apellido, :fecha_nacimiento,
            :direccion, :celular, :email, :sexo, :estado_civil, :tipo_persona,
            presence: { message: "es obligatorio" }

  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "no es válido"
  }

  validates :celular, length: {
    maximum: 20,
    message: "no puede tener más de 20 caracteres"
  }

  validates :identificacion, length: {
    maximum: 20,
    message: "no puede tener más de 20 caracteres"
  }

  validates :tipo_persona, inclusion: {
    in: TIPOS_PERSONA,
    message: "debe ser CASADO, SEMINARISTA o SOLTERO"
  }

  # VALIDACIONES OBLIGATORIAS DE ACEPTACIÓN
  validates :acepta_politica,
            acceptance: {
              accept: 'SI',
              message: 'Debes aceptar las políticas de tratamiento de datos personales'
            },
            presence: { message: 'Debes aceptar las políticas de tratamiento de datos personales' }

  validates :acepta_cultura,
            acceptance: {
              accept: 'SI',
              message: 'Debes aceptar la cultura organizacional'
            },
            presence: { message: 'Debes aceptar la cultura organizacional' }

  # Validación personalizada para no permitir duplicados en el mismo evento
  validates :identificacion, uniqueness: {
    scope: :evento_id,
    message: "ya está registrado para este evento"
  }

  # VALIDACIONES CONDICIONALES PARA MENORES DE EDAD
  validates :acudiente_nombre, :acudiente_apellido, :acudiente_identificacion,
            :acudiente_celular, :acudiente_email,
            presence: { message: "es obligatorio para menores de edad" },
            if: :menor_de_edad?

  validates :acudiente_email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" },
            if: :menor_de_edad?

  validate :validar_cupos_disponibles

  # Callbacks
  before_save :normalizar_datos
  before_validation :asegurar_aceptaciones

  # Método para verificar si es menor de edad
  def menor_de_edad?
    return false if fecha_nacimiento.blank?
    edad = calcular_edad
    edad < 18
  end

  # Método para calcular la edad
  def calcular_edad
    return 0 if fecha_nacimiento.blank?
    hoy = Date.current
    edad = hoy.year - fecha_nacimiento.year
    edad -= 1 if hoy < fecha_nacimiento + edad.years
    edad
  end

  def validar_cupos_disponibles
    if evento.lleno?
      errors.add(:base, "El evento ya alcanzó el número máximo de participantes")
    end
  end

  private

  def normalizar_datos
    self.nombre = nombre.upcase if nombre.present?
    self.apellido = apellido.upcase if apellido.present?
    self.direccion = direccion.upcase if direccion.present?
    self.acudiente_nombre = acudiente_nombre.upcase if acudiente_nombre.present?
    self.acudiente_apellido = acudiente_apellido.upcase if acudiente_apellido.present?
  end

  def asegurar_aceptaciones
    # Si los checkboxes no están marcados, asignar "NO"
    self.acepta_politica = "NO" if acepta_politica.blank?
    self.acepta_cultura = "NO" if acepta_cultura.blank?
  end


  def eventospersona_params
    params.require(:eventospersona).permit(
      :fecha_nacimiento, :evento_id,
      persona_attributes: {}  # permite **todos** los atributos de persona
    )
  end
end
