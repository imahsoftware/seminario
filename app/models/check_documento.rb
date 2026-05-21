class CheckDocumento < ApplicationRecord
  belongs_to :user, optional: true
  has_many :evento_check_documentos, dependent: :destroy
  has_many :eventos, through: :evento_check_documentos

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
end
