# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
<<<<<<< HEAD
# Add Yarn node_modules folder to the asset load path.
# Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w(_primary_theme.scss
                                                 pickr.min.js
                                                 monolith.min.scss
                                                 bootstrap-select.min.js
                                                 bootstrap-select.min.css)
=======
Rails.application.config.assets.paths << Rails.root.join('node_modules/bootstrap-icons/font')

# Precompile additional assets.
# application.jsx, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
