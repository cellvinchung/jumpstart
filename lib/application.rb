# frozen_string_literal: true

def update_application
  after_bundle do
    application do
      <<~RUBY
        config.generators do |g|
          g.assets false
          g.helper false
        end
        config.time_zone = "Taipei"
        config.i18n.fallbacks = [I18n.default_locale]
        config.i18n.default_locale = :"zh-TW"
        config.i18n.available_locales = [:"zh-TW", :en]
        config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
        config.middleware.insert_after ActionDispatch::Static, Rack::Deflater
        config.hosts << "lvh.me"
      RUBY
    end
    uncomment_lines 'config/environments/production.rb', /require_master_key/
  end
end
