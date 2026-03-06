class DocumentoTipo < ApplicationRecord
  has_many :eventospersonas
  has_many :personas
  has_many :documentos
  has_many :eventospersonas_acudientes, class_name: 'Eventospersona',
           foreign_key: 'acudiente_documento_tipo_id'
end
