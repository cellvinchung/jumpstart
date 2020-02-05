# frozen_string_literal: true

def setup_capistrano
  capistrano_gems

  after_bundle do
    run 'cap install'
    run 'cap sidekiq:install'

    custom_capfile
    custom_deploy
    set_staging
    set_config
  end
end

private

def capistrano_gems
  gem_group :development do
    gem 'capistrano-rails', require: false
    gem 'rvm1-capistrano3', require: false
    gem 'capistrano-passenger', require: false
    gem 'capistrano-upload-config', require: false
    gem 'capistrano-sidekiq', require: false
  end
end

def custom_capfile
  insert_into_file 'Capfile', after: "require \"capistrano/deploy\"\n" do
    <<~RUBY
      require 'rvm1/capistrano3'
      require 'capistrano/rails'
      require 'capistrano/passenger'
      require 'capistrano/upload-config'
      require 'capistrano/sidekiq'
      require 'capistrano/sidekiq/monit'
    RUBY
  end
end

def custom_deploy
  append_file 'config/deploy.rb' do
    <<~RUBY
      append :linked_files, 'config/database.yml', 'config/master.key',
         'config/storage.yml', 'config/gcs.json', 'config/sidekiq.yml', '.env'

      append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system',
       'public/packs', '.bundle', 'node_modules', 'data'
    RUBY
  end
end

def set_staging
  append_file 'config/deploy/staging.rb' do
    <<~RUBY
      set :rails_env, 'production'
    RUBY
  end
end

def set_config
  append_file 'config/deploy.rb' do
    <<~RUBY
      set :init_system, :systemd
      set :service_unit_name, "sidekiq-#{fetch(:application)}-#{fetch(:stage)}.service"
      set :sidekiq_monit_use_sudo, false

      before 'deploy', 'rvm1:install:rvm'
      before 'deploy:check:linked_files', 'config:push'
    RUBY
  end
end
