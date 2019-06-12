# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( skins/* )
Rails.application.config.assets.precompile += %w( *.js )
Rails.application.config.assets.precompile += %w( vendor.css )
