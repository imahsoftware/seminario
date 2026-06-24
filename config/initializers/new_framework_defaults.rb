# Este archivo era para la migración Rails 5.0.
# En Rails 7 estos valores son manejados por config.load_defaults 7.2 en application.rb
# Se conservan solo las líneas compatibles con Rails 7.

# Enable per-form CSRF tokens.
Rails.application.config.action_controller.per_form_csrf_tokens = true

# Enable origin-checking CSRF mitigation.
Rails.application.config.action_controller.forgery_protection_origin_check = true

# ELIMINADO (Rails 7): ActiveSupport.halt_callback_chains_on_return_false — método eliminado en Rails 6+
# ELIMINADO (Rails 7): ActiveSupport.to_time_preserves_timezone — ahora es default en Rails 7
# ELIMINADO (Rails 7): belongs_to_required_by_default — ahora es default en Rails 7
