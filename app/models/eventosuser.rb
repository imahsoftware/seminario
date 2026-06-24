class Eventosuser < ApplicationRecord
  belongs_to :user
  belongs_to :evento
  belongs_to :responsable, class_name: 'User', foreign_key: :user_administra, optional: true

  validates_presence_of  :user_administra
end
