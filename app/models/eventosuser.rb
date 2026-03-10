class Eventosuser < ApplicationRecord
  belongs_to :user
  belongs_to :evento

  validates_presence_of  :user_administra
end
