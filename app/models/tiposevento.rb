class Tiposevento < ApplicationRecord
  belongs_to :user

  validates_presence_of :descripcion, :estado
end
