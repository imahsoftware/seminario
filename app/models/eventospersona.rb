# app/models/eventospersona.rb
class Eventospersona < ApplicationRecord
  belongs_to :evento

  # Validaciones de campos obligatorios
  validates :identificacion, :nombre, :apellido, :fecha_nacimiento,
            :direccion, :celular, :email, :sexo, :estado_civil,
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

  # Callbacks
  before_save :normalizar_datos
  before_validation :asegurar_aceptaciones

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
end
