# app/models/eventoseliminado.rb
class Eventoseliminado < ApplicationRecord
  belongs_to :evento, optional: true
end