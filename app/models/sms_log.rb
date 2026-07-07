class SmsLog < ApplicationRecord
  self.table_name = 'sms_logs'

  belongs_to :evento,         optional: true
  belongs_to :eventospersona, optional: true

  TIPOS  = %w[AUTORIZACION_MENOR CREDENCIALES].freeze
  ESTADOS = %w[ENVIADO ERROR].freeze

  validates :tipo,  inclusion: { in: TIPOS }
  validates :estado, inclusion: { in: ESTADOS }

  scope :enviados, -> { where(estado: 'ENVIADO') }
  scope :errores,  -> { where(estado: 'ERROR') }
  scope :recientes, -> { order(created_at: :desc) }
end
