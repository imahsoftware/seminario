source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

#gem 'activerecord-oracle_enhanced-adapter', '~> 1.7'
#gem 'ruby-oci8', '~> 2.2.5'
#gem 'ruby-plsql'
# gem 'arel'  # DISABLED: desde Rails 6, arel está integrado en Rails core — gem separado genera conflictos
#gem 'tiny_tds'
gem 'activerecord-import'

#gem 'activerecord-sqlserver-adapter'
#gem 'pg'
gem 'mysql2', '~> 0.5'
# gem 'secondbase'  # DISABLED: no compatible con Rails 7 — Rails 7 tiene soporte nativo multi-DB
gem 'time_difference'
gem 'autonumeric-rails'
gem 'bootstrap-tooltip-rails'
gem 'bootstrap-sass', '~> 3.4'
gem 'font-awesome-sass', '~> 5.0'
gem "select2-rails"

# Paperclip — fork mantenido compatible con Rails 6+/7
# (drop-in replacement, misma API que paperclip original)
gem 'kt-paperclip'
gem 'marcel'  # reemplaza mimemagic (problemas de licencia GPL)

gem 'roo'
gem 'chart-js-rails'
gem 'barby'
gem 'chunky_png'
gem 'rqrcode'
# gem 'bootstrap-wysihtml5-rails'  # DISABLED: no compatible con Ruby 3.3
gem 'dotenv-rails'

gem 'authtrail'

# caxlsx + caxlsx_rails: fork mantenido de axlsx con soporte Ruby 3 / Rails 7
gem 'caxlsx', '~> 3.4'
gem 'caxlsx_rails', '~> 0.6'

# Google Map
gem 'gmaps4rails'

#Pdf Convert
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'whenever', :require => false

gem 'simple_form'
gem 'simple_form_autocomplete'
gem "highcharts-rails"
gem 'ransack'
gem "audited", "~> 5.0"
gem 'will_paginate'
gem 'will_paginate-bootstrap-style'
# gem 'remotipart'  # DISABLED: solo disponible para Ruby 2.7
gem 'rails-jquery-autocomplete'

#GEMAS DATEPICKER
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'jquery-ui-rails'
gem 'ionicons-rails' # Iconos ionicons — requiere fix_ionicons_precompile initializer

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.3'
# Use Puma as the app server
gem 'puma', '~> 6.0'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Sprockets for asset pipeline
gem 'sprockets-rails'
# Compressor JS
gem 'terser'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease.
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Faster boot
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.8'
  gem 'spring'
  gem 'brakeman'
  # gem 'bullet'  # DISABLED: incompatible con Ruby 3.3 — revisar versión compatible
end

gem 'devise'
gem 'devise-two-factor'
gem 'rqrcode_png'
gem 'devise-security'  # reemplaza devise_security_extension (phatworx) que solo soporta hasta Rails 6
gem 'devise_ssl_session_verifiable'
# server de jobs
gem 'sidekiq'
gem 'nice_http'
gem 'jquery-datatables'
gem 'ajax-datatables-rails'
# gem 'signature-pad-rails', '~> 1.0', '>= 1.0.1'  # DISABLED: solo JS, no compatible Ruby 3.3
gem 'prawn-rails'
gem 'sendgrid-ruby'
# gem 'best_in_place', '~> 3.0.1'  # DISABLED: no compatible con Ruby 3.3
gem 'leaflet-rails'
gem 'gruff'
gem 'rotp'
gem 'combine_pdf'
gem 'e2mmap'
gem 'coffee-rails', '~> 5.0'
gem 'csv'
