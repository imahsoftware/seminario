class Persona < ApplicationRecord
  belongs_to :documento_tipo, optional: true

  has_many :eventospersonas
  has_many :eventos, through: :evento_personas

end
