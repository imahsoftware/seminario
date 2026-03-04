class EstadoCivil < ApplicationRecord
  has_many :eventospersonas
  has_many :personas
end
