class Tiposevento < ApplicationRecord
  belongs_to :user

  validates_presence_of :descripcion, :estado

  def tipoevento_usado?
    Evento.where(tiposevento_id: self.id).exists?
  end
end
