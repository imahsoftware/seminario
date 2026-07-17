Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # En Rails 7, cache_classes fue reemplazado por enable_reloading
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Mailer
  config.action_mailer.default_url_options = { host: 'localhost', port: 4001 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    user_name:            'adconstrucciones1.nomina@gmail.com',
    password:             'Kenshin2165',
    authentication:       "plain",
    enable_starttls_auto: true
  }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # Rails 7: deprecation warnings (reemplaza config.active_support.deprecation = :log)
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Assets
  config.assets.debug = true
  config.assets.quiet = true

  config.i18n.available_locales = :es
end
