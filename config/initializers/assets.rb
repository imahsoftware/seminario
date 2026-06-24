# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# FIX Rails 7 / Ruby 3.3: Rails.root.join devuelve Pathname, Sprockets necesita String
# NOTA: NO agregar 'app/assets' ni 'app/assets/images/logos' — Sprockets 4 ya busca
# automáticamente en subdirectorios de app/assets/images. Agregar esas rutas crea
# logical paths duplicados que causan conflictos y assets no encontrados.
Rails.application.config.assets.paths << Rails.root.join('node_modules').to_s
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "AdminLTE").to_s
