class EventospersonaCheck < ApplicationRecord
  self.table_name = 'eventospersona_checks'

  belongs_to :eventospersona
  belongs_to :evento_check_documento

  validates :eventospersona_id, :evento_check_documento_id, presence: true
  validates :evento_check_documento_id, uniqueness: { scope: :eventospersona_id }

  before_save :registrar_fecha_aceptacion

  private

  def registrar_fecha_aceptacion
    self.fecha_aceptacion = Time.current if aceptado? && fecha_aceptacion.blank?
  end
end
