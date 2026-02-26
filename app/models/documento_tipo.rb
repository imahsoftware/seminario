class DocumentoTipo < ApplicationRecord
  has_many :eventospersonas
  has_many :personas
  has_many :documentos

end
