# app/models/documento.rb
class Documento < ApplicationRecord
  belongs_to :persona
  belongs_to :eventospersona

  has_attached_file :cedula_frente

  has_attached_file :cedula_reverso

  validates_attachment_content_type :cedula_frente,
                                    content_type: ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf']

  validates_attachment_content_type :cedula_reverso,
                                    content_type: ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf']


end