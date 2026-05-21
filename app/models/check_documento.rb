class CheckDocumento < ApplicationRecord
  belongs_to :user,       optional: true   # creador
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id', optional: true

  has_many :evento_check_documentos
  has_many :eventos, through: :evento_check_documentos

  before_destroy :verificar_sin_eventos

  has_attached_file :documento,
                    path: ':rails_root/public/system/check_documentos/:id/:filename',
                    url:  '/system/check_documentos/:id/:filename'

  validates_attachment_content_type :documento,
    content_type: %w[application/pdf application/msword
                     application/vnd.openxmlformats-officedocument.wordprocessingml.document]

  validates :titulo, presence: true
  validates :documento, presence: { message: "debe adjuntar un documento" }

  scope :activos, -> { where(estado: 'ACTIVO') }

  def documento_url
    documento.url rescue nil
  end

  private

  def verificar_sin_eventos
    if evento_check_documentos.exists?
      eventos_lista = eventos.pluck(:detalle).join(', ')
      errors.add(:base, "No se puede eliminar porque está asignado a: #{eventos_lista}")
      throw :abort
    end
  end
end
