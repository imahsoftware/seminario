class Iglesia < ApplicationRecord
  belongs_to :user
  has_many :iglesiascomunidades
  validates_presence_of :nombre, :presbitero,:direccion,:email,:telefono

  def iglesia_usado?
    Evento.where(iglesia_id: self.id).exists?
  end
end
