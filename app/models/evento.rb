class Evento < ApplicationRecord
  belongs_to :iglesia
  belongs_to :iglesiascomunidad
  belongs_to :tiposevento
  belongs_to :user
  has_many :eventospersonas, dependent: :destroy
  has_many :personas, through: :eventospersonas

  # ── Habeas Data desde tabla parametros ──────────────────────────
  belongs_to :habeas_data_parametro, class_name: 'Parametro',
             foreign_key: :habeas_data_parametro_id, optional: true

  before_validation :asegurar_guid, on: :create
  before_save :actualizar_url_si_necesario

  validates :guid, presence: true, uniqueness: true
  validates :iglesia_id, :tiposevento_id, :habeas_data_parametro_id,
            :fecha_fin, :fecha_inicio_e, :fecha_fin_e, presence: true

  validate :validar_fechas

  def actualizar_url_si_necesario
    return if guid.blank?
    if new_record? || guid_changed?
      base_url = Rails.env.production? ? "https://apps.srmmedellin.org/" : "https://apps.srmmedellin.org/
      self.url_publica = "#{base_url}/registro/#{self.guid}"
    end
  end

  def self.find_by_guid!(guid)
    find_by!(guid: guid)
  end

  def vigente?
    return false if fecha_inicio.nil? || fecha_fin.nil?
    Date.current.between?(fecha_inicio, fecha_fin)
  end

  def vencido?
    return false if fecha_fin.nil?
    Date.current > fecha_fin
  end

  def no_iniciado?
    return false if fecha_inicio.nil?
    Date.current < fecha_inicio
  end

  def hay_cupos?
    eventospersonas.count < cantidad_persona
  end

  def lleno?
    eventospersonas.count >= cantidad_persona
  end

  def to_param
    guid
  end

  def asegurar_guid!
    if guid.blank?
      asegurar_guid
      save(validate: false)
      generar_url_publica
    end
  end

  private

  def asegurar_guid
    if guid.blank?
      self.guid = generar_guid_corto
      while Evento.exists?(guid: self.guid)
        self.guid = generar_guid_corto
      end
    end
  end

  def generar_guid_corto
    charset = Array('A'..'Z') + Array('0'..'9')
    Array.new(8) { charset.sample }.join
  end

  def generar_url_publica
    return if guid.blank?
    base_url = Rails.env.production? ? "https://apps.srmmedellin.org/" : "https://apps.srmmedellin.org/"
    self.update_column(:url_publica, "#{base_url}/registro/#{self.guid}")
  end

  def validar_fechas
    return if fecha_inicio.blank? || fecha_fin.blank? ||
              fecha_inicio_e.blank? || fecha_fin_e.blank?

    if fecha_fin_e < fecha_inicio_e
      errors.add(:fecha_fin_e, "debe ser mayor o igual a la fecha de inicio del evento")
    end

    if fecha_fin > fecha_inicio_e
      errors.add(:fecha_fin, "no puede ser posterior al inicio del evento")
      errors.add(:fecha_inicio_e, "no puede empezar el evento sin cerrar inscripción")
    end

    if fecha_fin < fecha_inicio
      errors.add(:fecha_fin, "debe ser mayor o igual a la fecha de inicio de inscripción")
    end
  end
end