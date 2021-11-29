# frozen_string_literal: true

def setup_capistrano
  capistrano_gems

  after_bundle do
    run 'cap install'

    custom_capfile
    custom_deploy
    set_staging
    set_config
  end
end

private

def capistrano_gems
  gem_group :development do
    gem 'capistrano-rails', '~> 1.6', '>= 1.6.1', require: false
    gem 'capistrano-passenger', '~> 0.2.1', require: false
  end
end

def custom_capfile
  insert_into_file 'Capfile', after: "require \"capistrano/deploy\"\n" do
    <<~RUBY
      require 'capistrano/rails'
      require 'capistrano/passenger'
    RUBY
  end
end

def custom_deploy
  append_file 'config/deploy.rb' do
    <<~RUBY
      append :linked_files, 'config/database.yml', 'config/master.key',
         'config/storage.yml', 'config/*.json', 'config/sidekiq.yml', '.env', '.env.production',
         'config/credentials/production.key', 'config/credentials/development.key'

      append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system',
       'public/packs', '.bundle', 'node_modules', 'data'
    RUBY
  end
end

def set_staging
  append_file 'config/deploy/staging.rb' do
    <<~RUBY
      set :rails_env, 'staging'
    RUBY
  end

  run 'cp config/environments/production.rb config/environments/staging.rb'
end

def set_config
  append_file 'config/deploy.rb' do
    <<~RUBY
      set :conditionally_migrate, true

      set :sidekiq_roles, :app
      set :init_system, :systemd
      set :sidekiq_service_unit_name, "sidekiq.service"
      after 'deploy:starting', 'sidekiq:quiet'
      after 'deploy:updated', 'sidekiq:stop'
      after 'deploy:published', 'sidekiq:start'
      after 'deploy:failed', 'sidekiq:restart'
    RUBY
  end
end
