class Evento < ApplicationRecord
  belongs_to :iglesia
  belongs_to :iglesiascomunidad
  belongs_to :tiposevento
  belongs_to :user
  has_many :eventospersonas, dependent: :destroy

  validates_presence_of :iglesiascomunidad_id, :tiposevento_id, :fecha_inicio, :fecha_fin, :detalle, :estado
end
