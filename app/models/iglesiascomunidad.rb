class Iglesiascomunidad < ApplicationRecord
  belongs_to :iglesia
  belongs_to :user

  validates_presence_of :nombre, :estado
end
