# frozen_string_literal: true

def add_gems
  gem_group :development, :test do
    gem 'factory_bot_rails'
    gem 'faker', git: 'https://github.com/stympy/faker.git'
    gem 'dotenv-rails'
    gem 'hirb'
    gem 'hirb-unicode-steakknife'
    gem 'pry-byebug'
    gem 'pry-stack_explorer'
  end

  gem_group :development do
    gem 'brakeman', require: false
    gem 'capistrano-rails'
    gem 'rvm1-capistrano3', require: false
    gem 'capistrano-passenger'

    # Entity-Relationship Diagrams
    gem 'rails-erd'

    gem 'rspec-rails', '~> 3.7'
    gem 'i18n-spec'
    gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
    gem 'better_errors'
    gem 'binding_of_caller'

    # find n + 1
    gem 'bullet'

    gem 'pry-rails'
    gem 'cacheflow'
    gem 'letter_opener'
    gem 'bumbler', require: false # 測試每個 gem 的加載速度
    gem 'rack-mini-profiler', require: false
    gem 'memory_profiler'
    gem 'flamegraph'
    gem 'stackprof'
    gem 'fast_stack'
  end
  gem_group :staging, :development, :test do
    # Dev helpers
    gem 'awesome_rails_console', require: false
  end
  gem_group :production, :staging do
    gem 'cloudflare-rails'
  end

  # 異步執行等相關任務，非啟動就需要執行在 Test 環境下不該被加載
  gem_group :production, :development, :staging do
    gem 'sidekiq', '>= 6'
    gem 'sidekiq-statistic', git: 'https://github.com/davydovanton/sidekiq-statistic.git'
    gem 'sidekiq-cron', '~> 1.1'
    gem 'sidekiq-unique-jobs'
    gem 'sidekiq-status'
    gem 'whenever', require: false
  end

  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'jquery-timepicker-addon-rails'
  gem 'bootstrap', '~> 4.3', '>= 4.3.1'
  gem 'font-awesome-sass', '~> 5.9', '>= 5.9.0'
  gem 'simple_form'
  gem 'cocoon'

  # A performance dashboard for Postgres
  gem 'pghero'
  gem 'pg_query', '>= 0.9.0'

  gem 'devise', '~> 4.7', '>= 4.7.0'
  gem 'devise-i18n'

  gem 'friendly_id', '~> 5.2', '>= 5.2.5'
  gem 'babosa'

  gem 'mini_magick', '~> 4.9', '>= 4.9.2'

  gem 'omniauth-facebook', '~> 5.0'
  gem 'omniauth-github', '~> 1.3'
  gem 'omniauth-twitter', '~> 1.4'

  gem 'discard', '~> 1.0'

  # fast JSON parser and Object marshaller
  gem 'oj'
  gem 'fast_jsonapi'

  # 移除欄位空白
  gem 'strip_attributes'

  # breadcrumb
  gem 'loaf', git: 'https://github.com/piotrmurach/loaf'

  gem 'browser'
  # meta tag
  gem 'meta-tags'

  gem 'sitemap_generator', '~> 6.0', '>= 6.0.1'

  # 錯誤通知
  gem 'exception_notification'
  gem 'slack-notifier'

  # 狀態機
  gem 'aasm'
  # Presenters
  gem 'draper'

  gem 'pagy', git: 'https://github.com/ddnexus/pagy'

  gem 'http'

  gem 'ruby-progressbar', require: false
  gem 'active_link_to'
  gem 'image_processing'
  gem 'premailer-rails'

  gem 'active_hash'
  gem 'decent_exposure', '3.0.2'

  # bulk insert
  gem 'activerecord-import'

  # get your Rails variables in your js
  gem 'gon'

  # i18n
  gem 'rails-i18n'
  gem 'i18n-js'

end

def setup_js
  run 'yarn add expose-loader jquery popper.js bootstrap data-confirm-modal local-time'

  content = <<-JS
    const webpack = require('webpack')
    environment.plugins.append('Provide', new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      Rails: '@rails/ujs'
    }))
  JS

  insert_into_file 'config/webpack/environment.js', content + "\n", before: 'module.exports = environment'
end

def setup_simple_form
  generate 'simple_form:install --bootstrap'
end

def setup_annotate
  generate 'annotate:install'

  gsub_file 'lib/tasks/auto_annotate_models.rake',
            /'position_in_class'         => 'before'/,
            "'position_in_class'         => 'bottom'"

  run 'bundle exec annotate'
end

def setup_whenever
  run 'wheneverize .'
end

def setup_sitemap
  rails_command 'sitemap:install'
end

def setup_meta_tag
  generate 'meta_tags:install'

  insert_into_file 'app/views/layouts/application.html.erb',
                   '<%= display_meta_tags %>',
                   after: "<head>\n"
end

def setup_bullet
  content = <<-RUBY
    config.after_initialize do
      Bullet.enable = true
      Bullet.add_footer = true
    end
  RUBY

  environment "#{content}\n\n", env: 'development'
end

def setup_letter_opener
  environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'
  environment 'config.action_mailer.perform_deliveries = true', env: 'development'
end

def setup_dotenv
  file '.env', <<-CODE

  CODE
end

def setup_locale
  application do
    "config.generators do |g| \n
      g.stylesheets false \n
    end \n
    config.time_zone = \"Taipei\" \n
    config.i18n.fallbacks = [I18n.default_locale] \n
    config.i18n.default_locale = :\"zh-TW\" \n
    config.i18n.available_locales = [:\"zh-TW\", :en] \n
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]"
  end
end

def setup_devise
  generate 'devise:install'
  environment "config.action_mailer.default_url_options = { host: 'lvh.me', port: 5000 }", env: 'development'
  generate 'devise:i18n:locale zh-TW'

  devise_model = ask('input devise_model')
  devise_model ||= 'user'

  generate 'devise', devise_model
  generate "devise:i18n:views #{devise_model}"
  gsub_file 'config/initializers/devise.rb',
            /  # config.secret_key = .+/,
            '  config.secret_key = Rails.application.credentials.dig(:secret_key_base)'
end

def setup_friendly_id
  generate 'friendly_id'
end

def setup_pghero
  content = <<-RUBY
    mount PgHero::Engine, at: 'pghero'
  RUBY

  insert_into_file 'config/routes.rb', "#{content}\n\n", after: "Rails.application.routes.draw do\n"

  generate 'pghero:config'
  generate 'pghero:query_stats'
  generate 'pghero:space_stats'
end

def init_pghero
  rails_command 'pghero:capture_query_stats'
  rails_command 'pghero:capture_space_stats'
end

def setup_sidekiq
  application 'config.active_job.queue_adapter = :sidekiq'

  insert_into_file 'config/routes.rb',
                   "require 'sidekiq/web'\n
     require 'sidekiq-status/web'\n\n",
                   before: 'Rails.application.routes.draw do'

  content = <<-RUBY
    mount Sidekiq::Web => '/sidekiq'
  RUBY

  insert_into_file 'config/routes.rb', "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def setup_activestorage
  rails_command 'active_storage:install'

  # TODO: setup direct_upload
end

def setup_premailer
  file 'config/premailer_rails.rb', <<-RUBY
    Premailer::Rails.config.merge!(preserve_styles: true, remove_ids: true, input_encoding: 'UTF-8')
  RUBY
end

def setup_pry
  environment 'config.console = Pry', env: 'development'
end

def setup_rollbar
  rollbar_key = ask("input rollbar_key")
  gererate "rollbar #{rollbar_key}"
end

def setup_exception_notification
  initializer 'exception_notification.rb' do
    require 'exception_notification/sidekiq'
    ExceptionNotification.configure do |config|
      config.ignore_if do |_exception, _options|
        Rails.env.development?
      end
      config.add_notifier :slack,
                          webhook_url: Rails.application.credentials.dig(:slack, :webhook_url),
                          ignore_crawlers: %w[Googlebot bingbot],
                          additional_parameters: {
                            mrkdwn: true
                          }
    end
  end
end

def stop_spring
  run 'spring stop'
end

add_gems
after_bundle do
  rails_command 'db:create'
  stop_spring
  setup_activestorage
  setup_js
  setup_simple_form
  setup_whenever
  setup_sitemap
  setup_meta_tag
  setup_bullet
  setup_letter_opener
  setup_dotenv
  setup_locale
  setup_devise
  setup_friendly_id
  setup_pghero
  setup_sidekiq
  setup_premailer
  setup_pry
  setup_rollbar

  rails_command 'db:migrate'

  init_pghero
  setup_annotate
end
