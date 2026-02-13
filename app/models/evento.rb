class Evento < ApplicationRecord

  belongs_to :iglesia
  belongs_to :iglesiascomunidad
  belongs_to :tiposevento
  belongs_to :user
  has_many :eventospersonas, dependent: :destroy

  before_create :generar_guid
  after_create :generar_url_publica

  validates :guid, uniqueness: true, allow_nil: true
  validates :fecha_inicio, :fecha_fin, :detalle, :estado , presence: true
  validate :fecha_fin_mayor_que_inicio


  def self.find_by_guid!(guid)
    find_by!(guid: guid)
  end

  # Método para verificar si el evento está vigente
  def vigente?
    return false if fecha_inicio.nil? || fecha_fin.nil?
    Date.current.between?(fecha_inicio, fecha_fin)
  end

  # Método para verificar si el evento está vencido
  def vencido?
    return false if fecha_fin.nil?
    Date.current > fecha_fin
  end

  # Método para verificar si el evento aún no ha iniciado
  def no_iniciado?
    return false if fecha_inicio.nil?
    Date.current < fecha_inicio
  end

  # Override del método to_param para usar GUID en las URLs
  def to_param
    guid
  end

  private

  def generar_guid
    self.guid = SecureRandom.uuid if guid.blank?
  end

  def generar_url_publica
    base_url = Rails.env.production? ? "http://165.227.63.186" : "http://localhost:3000"
    self.update_column(:url_publica, "#{base_url}/registro/#{self.guid}")
  end

  def fecha_fin_mayor_que_inicio
    return if fecha_inicio.blank? || fecha_fin.blank?

    if fecha_fin < fecha_inicio
      errors.add(:fecha_fin, "debe ser mayor o igual a la fecha de inicio")
    end
  end
end
