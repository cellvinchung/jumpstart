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
  end

  gem_group :production, :development do
    gem 'active_link_to', '~> 1.0', '>= 1.0.5'
    gem 'ruby-progressbar', '~> 1.10', '>= 1.10.1', require: false
    gem 'local_time', '~> 2.1'
  end

  gem 'image_processing', '~> 1.12', '>= 1.12.1'
  gem 'discard', '~> 1.2'

  gem 'oj', '~> 3.10', '>= 3.10.17'

  # 移除欄位空白
  gem 'strip_attributes', '~> 1.11'

  gem 'browser', '~> 5.2'

  # 狀態機
  gem 'aasm', '~> 5.1', '>= 5.1.1'
  # prevent race conditions and redundant callback calls within nested transaction
  gem 'after_commit_everywhere', '~> 0.1.5'

  gem 'http', '~> 4.4', '>= 4.4.1'

  gem 'active_hash', '~> 3.1'

  # bulk insert
  gem 'activerecord-import', '~> 1.0', '>= 1.0.7'

  gem 'inline_svg', '~> 1.7', '>= 1.7.2'

  gem 'counter_culture', '~> 2.7'

  # do conditions based on the associations of your records
  gem 'activerecord_where_assoc', '~> 1.1'

  gem 'rack-attack', '~> 6.3', '>= 6.3.1'

  gem 'groupdate', '~> 5.2', '>= 5.2.1', require: false

  gem 'deep_cloneable', '~> 3.0'

  gem 'paper_trail', '~> 11.1'
end

def finalize_setting
  after_bundle do
    rails_command 'db:migrate'
    setup_paper_trail
    run 'gem install rubocop-rails'
    run 'gem install solargraph'
  end
end

require_relative "lib/annotate"
require_relative "lib/application"
require_relative "lib/bullet"
require_relative "lib/capistrano"
require_relative "lib/devise"
require_relative "lib/draper"
require_relative "lib/dotenv"
require_relative "lib/error_handling"
require_relative "lib/exception_notification"
require_relative "lib/foreman"
require_relative "lib/friendly_id"
require_relative "lib/gitignore"
require_relative "lib/gon"
require_relative "lib/i18n"
require_relative "lib/letter_opener"
require_relative "lib/loaf"
require_relative "lib/lockbox"
require_relative "lib/lograge"
require_relative "lib/marginalia"
require_relative "lib/meta_tag"
require_relative "lib/notable"
require_relative "lib/pagy"
require_relative "lib/paper_trail"
require_relative "lib/pghero"
require_relative "lib/premailer_rails"
require_relative "lib/pry_rails"
require_relative "lib/rack_mini_profiler"
require_relative "lib/rollbar"
require_relative "lib/rollout"
require_relative "lib/sidekiq"
require_relative "lib/simple_form"
require_relative "lib/sitemap"
require_relative "lib/slowpoke"
require_relative "lib/webpack"
require_relative "lib/whenever"

add_common_gems
after_bundle do
  rails_command 'db:create'
  run 'spring stop'
end

update_application
setup_devise
setup_annotate
setup_webpack
setup_i18n
setup_capistrano
setup_simple_form
setup_gon
setup_meta_tag
setup_pagy
setup_loaf
setup_draper
setup_friendly_id
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
setup_rollout
setup_lockbox
setup_whenever
setup_sitemap
setup_slowpoke
setup_pry_rails
setup_notable
setup_lograge
update_gitignore
setup_error_handling
setup_foreman
finalize_setting

puts 'Change paper trail object data type then run migration'