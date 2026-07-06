class EventoCheckDocumento < ApplicationRecord
  belongs_to :evento
  belongs_to :check_documento
  has_many :eventospersona_checks, dependent: :destroy

  APLICA_PARA_OPCIONES = [
    ['Mayores de edad',  'ADULTO'],
    ['Menores de edad',  'MENOR'],
    ['Todos',            'AMBOS']
  ].freeze

  validates :evento_id, :check_documento_id, presence: true
  validates :check_documento_id, uniqueness: { scope: :evento_id,
            message: "ya está asignado a este evento" }
  validates :aplica_para, inclusion: { in: %w[ADULTO MENOR AMBOS] }

  default_scope { order(:orden) }
end
