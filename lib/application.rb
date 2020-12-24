# frozen_string_literal: true

def update_application
  after_bundle do
    application do
      <<~RUBY
        config.generators do |g|
          g.stylesheets false
          g.helper false
          g.decorator false
        end
        config.time_zone = "Asia/Taipei"
        config.i18n.fallbacks = [I18n.default_locale]
        config.i18n.default_locale = :"zh-TW"
        config.i18n.available_locales = [:"zh-TW", :en]
        config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
      RUBY
    end
    set_development
    set_production
  end
end

def set_development
  environment(env: 'development') do
    <<~RUBY
      config.hosts << "lvh.me"
      config.hosts << '.ngrok.io'
      config.middleware.insert_after ActionDispatch::Static, Rack::Deflater
      routes.default_url_options[:host] = 'lvh.me:3000'
    RUBY
  end
end

def set_production
  environment(env: 'production') do
    config.exceptions_app = routes
    config.action_mailer.default_url_options = { host: ENV['DOMAIN'], port: ENV['PORT'] }
    config.cache_store = :redis_cache_store, { url: "#{ENV.fetch('REDIS_URL') {'redis://localhost:6379'}}/0" }
  end
  uncomment_lines 'config/environments/production.rb', /require_master_key/
  uncomment_lines 'config/environments/production.rb', "config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' "

end
