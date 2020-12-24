# frozen_string_literal: true

def setup_capistrano
  capistrano_gems

  after_bundle do
    run 'cap install'
    # run 'cap sidekiq:install'

    custom_capfile
    custom_deploy
    set_staging
    set_config
  end
end

private

def capistrano_gems
  gem_group :development do
    gem 'capistrano-rails', '~> 1.4', require: false
    gem 'rvm1-capistrano3', '~> 1.4', require: false
    gem 'capistrano-passenger', '~> 0.2.0', require: false
  end
end

def custom_capfile
  insert_into_file 'Capfile', after: "require \"capistrano/deploy\"\n" do
    <<~RUBY
      require 'rvm1/capistrano3'
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
      set :rails_env, 'production'
    RUBY
  end
end

def set_config
  append_file 'config/deploy.rb' do
    <<~RUBY
      set :conditionally_migrate, true

      SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq -e #{fetch(:stage)}"
      set :sidekiq_roles, :app
      set :init_system, :systemd
      set :sidekiq_service_unit_name, "sidekiq.service"
      set :sidekiq_monit_use_sudo, true
      after 'deploy:starting', 'sidekiq:quiet'
      after 'deploy:updated', 'sidekiq:stop'
      after 'deploy:published', 'sidekiq:start'
      after 'deploy:failed', 'sidekiq:restart'

      namespace :app do
        task :update_rvm_key do
          on roles(:all) do |host|
            execute :gpg, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
          end
        end
      end
      before "rvm1:install:rvm", "app:update_rvm_key"
      # set :tmp_dir, "/home/username/tmp"  #set tmp folder
      before 'deploy', 'rvm1:install:rvm'
      Rake::Task["rvm1:install:ruby"].clear_prerequisites
      before 'bundler:config', 'rvm1:install:ruby'
      before 'deploy', 'rvm1:alias:create'
    RUBY
  end
end

def set_sidekiq_task
  add_file 'lib/capistrano/tasks/sidekiq.rake' do
    <<~RUBY
      # https://github.com/seuros/capistrano-sidekiq/issues/224#issuecomment-525308963
      namespace :sidekiq do
        desc 'Quiet sidekiq (stop fetching new tasks from Redis)'
        task :quiet do
          on roles fetch(:sidekiq_roles) do
            # See: https://github.com/mperham/sidekiq/wiki/Signals#tstp
            execute :sudo, :systemctl, 'kill', '-s', 'SIGTSTP', fetch(:sidekiq_service_unit_name), raise_on_non_zero_exit: false
          end
        end

        desc 'Stop sidekiq (graceful shutdown within timeout, put unfinished tasks back to Redis)'
        task :stop do
          on roles fetch(:sidekiq_roles) do
            # See: https://github.com/mperham/sidekiq/wiki/Signals#tstp
            execute :sudo, :systemctl, 'kill', '-s', 'SIGTERM', fetch(:sidekiq_service_unit_name), raise_on_non_zero_exit: false
          end
        end

        desc 'Start sidekiq'
        task :start do
          on roles fetch(:sidekiq_roles) do
            execute :sudo, :systemctl, 'start', fetch(:sidekiq_service_unit_name)
          end
        end

        desc 'Restart sidekiq'
        task :restart do
          on roles fetch(:sidekiq_roles) do
            execute :sudo, :systemctl, 'restart', fetch(:sidekiq_service_unit_name)
          end
        end
      end
    RUBY
  end
end
