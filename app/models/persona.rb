class Persona < ApplicationRecord
  belongs_to :documento_tipo

  has_many :eventospersonas
  has_many :eventos, through: :evento_personas

end
