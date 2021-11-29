# frozen_string_literal: true

def add_common_gems
  gem_group :development, :test do
    gem 'rspec-rails', '~> 5.0', '>= 5.0.2'
    gem 'factory_bot_rails', '~> 6.2'
    gem 'faker', '~> 2.19'
  end
  gem_group :test do
    gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
  end
  gem_group :development do
    gem 'brakeman', '~> 5.1', '>= 5.1.2', require: false

    # Entity-Relationship Diagrams
    gem 'rails-erd', '~> 1.6', '>= 1.6.1'

    gem 'cacheflow', '~> 0.1.1'
  end

  gem_group :production, :staging, :development do
    gem 'active_link_to', '~> 1.0', '>= 1.0.5'
    gem 'local_time', '~> 2.1'
  end

  gem 'image_processing', '~> 1.12', '>= 1.12.1'
  gem 'discard', '~> 1.2'

  gem 'oj', '~> 3.13', '>= 3.13.9'

  # 移除欄位空白
  gem 'strip_attributes', '~> 1.11'

  gem 'browser', '~> 5.3', '>= 5.3.1'

  # 狀態機
  gem 'aasm', '~> 5.2'
  # prevent race conditions and redundant callback calls within nested transaction
  gem 'after_commit_everywhere', '~> 1.1'

  gem 'http', '~> 5.0', '>= 5.0.4'

  # bulk insert
  gem 'activerecord-import', '~> 1.2'

  gem 'inline_svg', '~> 1.7', '>= 1.7.2'

  gem 'counter_culture', '~> 3.0'
  gem 'after_commit_action', '~> 1.1'

  # do conditions based on the associations of your records
  gem 'activerecord_where_assoc', '~> 1.1', '>= 1.1.2'

  gem 'rack-attack', '~> 6.5'

  gem 'groupdate', '~> 5.2', '>= 5.2.2'

  gem 'deep_cloneable', '~> 3.1'

  gem 'paper_trail', '~> 12.1'
end

def finalize_setting
  after_bundle do
    setup_paper_trail
    rails_command 'db:migrate'
    run 'gem install rubocop-rails'
    run 'gem install solargraph'
  end
end

require_relative "lib/annotate"
require_relative "lib/application"
require_relative "lib/better_errors"
require_relative "lib/bullet"
require_relative "lib/capistrano"
require_relative "lib/devise"
require_relative "lib/draper"
require_relative "lib/dotenv"
require_relative "lib/error_handling"
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
require_relative "lib/pagy"
require_relative "lib/paper_trail"
require_relative "lib/premailer_rails"
require_relative "lib/pry_rails"
require_relative "lib/rack_mini_profiler"
require_relative "lib/flipper"
require_relative "lib/sidekiq"
require_relative "lib/simple_form"
require_relative "lib/sitemap"
require_relative "lib/slowpoke"
require_relative "lib/webpack"
require_relative "lib/whenever"

add_common_gems
after_bundle do
  run 'spring stop'
  rails_command 'db:create'
end

update_application
setup_better_errors
setup_annotate
setup_webpack
setup_i18n
setup_simple_form
setup_gon
setup_meta_tag
setup_pagy
setup_loaf
setup_draper
setup_friendly_id
setup_sidekiq
setup_marginalia
setup_bullet
setup_letter_opener
setup_premailer
setup_dotenv
setup_rack_mini_profiler
setup_flipper
setup_devise
setup_lockbox
setup_slowpoke
setup_pry_rails
setup_lograge
setup_capistrano
setup_whenever
setup_sitemap
update_gitignore
setup_error_handling
setup_foreman
finalize_setting

puts 'Change paper trail object data type then run migration'