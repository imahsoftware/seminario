class Iglesiascomunidad < ApplicationRecord
  belongs_to :iglesia
  belongs_to :user
end
