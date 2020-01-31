# frozen_string_literal: true

def add_common_gems
  gem_group :development, :test do
    gem 'factory_bot_rails'
    gem 'faker', git: 'https://github.com/stympy/faker.git'
  end

  gem_group :development do
    gem 'brakeman', require: false

    # Entity-Relationship Diagrams
    gem 'rails-erd'
    gem 'hirb-unicode', require: false
    gem 'rspec-rails', '~> 3.7'
    gem 'i18n-spec'
    gem 'better_errors'
    gem 'binding_of_caller'

    gem 'cacheflow'
    gem 'rubocop-rails', require: false
    gem 'solargraph', require: false
    gem 'bumbler', require: false # 測試每個 gem 的加載速度
    gem 'rack-mini-profiler', require: false
    gem 'memory_profiler'
    gem 'flamegraph'
    gem 'stackprof'
    gem 'fast_stack'
  end

  gem_group :production, :development do
    gem 'cocoon'
    gem 'active_link_to'
    gem 'ruby-progressbar', require: false
  end

  gem 'image_processing'
  gem 'discard', '~> 1.0'

  gem 'oj'

  # 移除欄位空白
  gem 'strip_attributes'

  gem 'browser'

  # 狀態機
  gem 'aasm'

  gem 'http'

  gem 'image_processing'

  gem 'active_hash'
  gem 'decent_exposure', '3.0.2'

  # bulk insert
  gem 'activerecord-import'

  gem 'inline_svg'

  gem 'counter_culture', '~> 2.0'

  # do conditions based on the associations of your records
  gem 'activerecord_where_assoc', '~> 1.0'
end

def setup_activestorage
  rails_command 'active_storage:install'

  # TODO: setup direct_upload
end

def finalize_setting
  after_bundle do
    rails_command 'db:migrate'
    setup_annotate
  end
end

jumpstart_folder = 'jumpstart/lib'
require "../#{jumpstart_folder}/annotate"
require "../#{jumpstart_folder}/application"
require "../#{jumpstart_folder}/bullet"
require "../#{jumpstart_folder}/capistrano"
require "../#{jumpstart_folder}/cloudflare"
require "../#{jumpstart_folder}/devise"
require "../#{jumpstart_folder}/draper"
require "../#{jumpstart_folder}/dotenv"
require "../#{jumpstart_folder}/exception_notification"
require "../#{jumpstart_folder}/friendly_id"
require "../#{jumpstart_folder}/gitignore"
require "../#{jumpstart_folder}/gon"
require "../#{jumpstart_folder}/i18n"
require "../#{jumpstart_folder}/letter_opener"
require "../#{jumpstart_folder}/loaf"
require "../#{jumpstart_folder}/meta_tag"
require "../#{jumpstart_folder}/pagy"
require "../#{jumpstart_folder}/pghero"
require "../#{jumpstart_folder}/premailer_rails"
require "../#{jumpstart_folder}/pry_rails"
require "../#{jumpstart_folder}/rollbar"
require "../#{jumpstart_folder}/sidekiq"
require "../#{jumpstart_folder}/simple_form"
require "../#{jumpstart_folder}/sitemap"
require "../#{jumpstart_folder}/webpack"
require "../#{jumpstart_folder}/whenever"

add_common_gems
after_bundle do
  rails_command 'db:create'
  run 'spring stop'
  setup_activestorage
end

setup_webpack
setup_i18n
update_application
setup_simple_form
setup_gon
setup_meta_tag
setup_pagy
setup_loaf
setup_draper
setup_friendly_id
setup_devise
setup_sidekiq
# setup_pghero
setup_exception_notification
setup_bullet
setup_letter_opener
setup_premailer
setup_dotenv
setup_rollbar
setup_capistrano
setup_whenever
setup_sitemap
setup_pry_rails
update_gitignore
setup_cloudflare
finalize_setting
