# frozen_string_literal: true

def add_common_gems
  gem_group :development, :test do
    gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
    gem 'faker', '~> 2.10', '>= 2.10.2'
    gem 'database_cleaner'
  end

  gem_group :development do
    gem 'brakeman', '~> 4.8', require: false

    # Entity-Relationship Diagrams
    gem 'rails-erd', '~> 1.6'
    gem 'rspec-rails', '~> 3.7'
    gem 'i18n-spec', github: 'tigrish/i18n-spec'
    gem 'better_errors', '~> 2.6'
    gem 'binding_of_caller', '~> 0.8.0'

    gem 'cacheflow', '~> 0.1.1'
    gem 'rubocop-rails', '~> 2.4', '>= 2.4.2', require: false
    gem 'solargraph', '~> 0.38.5', require: false
  end

  gem_group :production, :development do
    gem 'active_link_to', '~> 1.0', '>= 1.0.5'
    gem 'ruby-progressbar', '~> 1.10', '>= 1.10.1', require: false
  end

  gem 'image_processing', '~> 1.10', '>= 1.10.3'
  gem 'discard', '~> 1.2'

  gem 'oj', '~> 3.10', '>= 3.10.3'

  # 移除欄位空白
  gem 'strip_attributes', '~> 1.9', '>= 1.9.2'

  gem 'browser', '~> 4.0'

  # 狀態機
  gem 'aasm', '~> 5.0', '>= 5.0.6'

  gem 'http', '~> 4.3'

  gem 'active_hash', '~> 3.1'
  gem 'decent_exposure', '3.0.2'

  # bulk insert
  gem 'activerecord-import', '~> 1.0', '>= 1.0.4'

  gem 'inline_svg', '~> 1.7'

  gem 'counter_culture', '~> 2.0'

  # do conditions based on the associations of your records
  gem 'activerecord_where_assoc', '~> 1.1'

  gem 'rack-attack', '~> 6.2', '>= 6.2.2'

  gem 'groupdate', '~> 5.0', require: false
end

def setup_action_text
  rails_command 'action_text:install'
end

def finalize_setting
  after_bundle do
    rails_command 'db:migrate'
  end
end

$jumpstart_folder = 'jumpstart/lib'
require "../#{$jumpstart_folder}/annotate"
require "../#{$jumpstart_folder}/application"
require "../#{$jumpstart_folder}/audited"
require "../#{$jumpstart_folder}/bullet"
require "../#{$jumpstart_folder}/capistrano"
require "../#{$jumpstart_folder}/cloudflare"
require "../#{$jumpstart_folder}/devise"
require "../#{$jumpstart_folder}/draper"
require "../#{$jumpstart_folder}/dotenv"
require "../#{$jumpstart_folder}/error_handling"
require "../#{$jumpstart_folder}/exception_notification"
require "../#{$jumpstart_folder}/foreman"
require "../#{$jumpstart_folder}/friendly_id"
require "../#{$jumpstart_folder}/gitignore"
require "../#{$jumpstart_folder}/gon"
require "../#{$jumpstart_folder}/i18n"
require "../#{$jumpstart_folder}/letter_opener"
require "../#{$jumpstart_folder}/loaf"
require "../#{$jumpstart_folder}/lockbox"
require "../#{$jumpstart_folder}/lograge"
require "../#{$jumpstart_folder}/marginalia"
require "../#{$jumpstart_folder}/meta_tag"
require "../#{$jumpstart_folder}/notable"
require "../#{$jumpstart_folder}/pagy"
require "../#{$jumpstart_folder}/pghero"
require "../#{$jumpstart_folder}/premailer_rails"
require "../#{$jumpstart_folder}/pry_rails"
require "../#{$jumpstart_folder}/rack_mini_profiler"
require "../#{$jumpstart_folder}/rollbar"
require "../#{$jumpstart_folder}/sidekiq"
require "../#{$jumpstart_folder}/simple_form"
require "../#{$jumpstart_folder}/sitemap"
require "../#{$jumpstart_folder}/slowpoke"
require "../#{$jumpstart_folder}/webpack"
require "../#{$jumpstart_folder}/whenever"

add_common_gems
after_bundle do
  rails_command 'db:create'
  run 'spring stop'
  setup_action_text
end

setup_annotate
setup_webpack
setup_i18n
update_application
setup_capistrano
setup_simple_form
setup_gon
setup_meta_tag
setup_pagy
setup_loaf
setup_draper
setup_friendly_id
setup_devise
setup_audited
setup_sidekiq
setup_pghero
setup_marginalia
# setup_exception_notification
setup_bullet
setup_letter_opener
setup_premailer
setup_dotenv
setup_rack_mini_profiler
setup_rollbar
setup_lockbox
setup_whenever
setup_sitemap
setup_slowpoke
setup_pry_rails
setup_notable
setup_lograge
update_gitignore
setup_cloudflare
setup_error_handling
setup_foreman
finalize_setting
