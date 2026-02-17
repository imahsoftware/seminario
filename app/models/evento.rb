class Evento < ApplicationRecord
  belongs_to :iglesia
  belongs_to :iglesiascomunidad
  belongs_to :tiposevento
  belongs_to :user
  has_many :eventospersonas, dependent: :destroy

  before_validation :asegurar_guid, on: :create
  before_save :actualizar_url_si_necesario # usamos before_save seguro

  validates :guid, presence: true, uniqueness: true
  validates :fecha_inicio, :fecha_fin, presence: true
  validate :fecha_fin_mayor_que_inicio

  # Genera o actualiza la URL antes de guardar
  def actualizar_url_si_necesario
    return if guid.blank?

    # Rails <5.1 usa `guid_changed?`, >=5.1 puede usar `saved_change_to_guid?` en after_save
    if new_record? || guid_changed?
      base_url = Rails.env.production? ? "https://tudominio.com" : "http://localhost:3000"
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

    base_url = Rails.env.production? ? "https://tudominio.com" : "http://localhost:3000"
    self.update_column(:url_publica, "#{base_url}/registro/#{self.guid}")
  end



  def fecha_fin_mayor_que_inicio
    return if fecha_inicio.blank? || fecha_fin.blank?

    if fecha_fin < fecha_inicio
      errors.add(:fecha_fin, "debe ser mayor o igual a la fecha de inicio")
    end
  end
end
