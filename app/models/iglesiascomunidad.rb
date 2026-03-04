class Iglesiascomunidad < ApplicationRecord
  belongs_to :iglesia
  belongs_to :user

  validates_presence_of :nombre, :estado


  def iglesiacomunidad_usado?
    Evento.where(iglesiascomunidad_id: self.id).exists?
  end
end
