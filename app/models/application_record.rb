class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Ransack 4+ (Rails 7) requiere declarar atributos buscables explícitamente.
  # Para mantener compatibilidad con el comportamiento de Rails 5, permitimos todos.
  # En producción, considera declarar los atributos por modelo para mayor seguridad.
  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end
end
