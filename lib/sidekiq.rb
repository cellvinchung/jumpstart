# frozen_string_literal: true

def setup_sidekiq
  sidekiq_gems

  after_bundle do
    application 'config.active_job.queue_adapter = :sidekiq'
    custom_sidekiq
    custom_routes
    custom_yml
    set_sidekiq_task
  end
end

private

def sidekiq_gems
  gem_group :production, :development, :staging do
    gem 'sidekiq', '~> 6.3', '>= 6.3.1'
    gem 'sidekiq-failures', '~> 1.0', '>= 1.0.1'
    gem 'sidekiq-statistic', '~> 1.4'
    gem 'sidekiq-scheduler', '~> 3.1'
    gem 'sidekiq-unique-jobs', '~> 7.1', '>= 7.1.8'
    gem 'sidekiq-status', '~> 2.1'
    gem 'activejob-traffic_control', '~> 0.1.3'
  end
end

def custom_sidekiq
  initializer 'sidekiq.rb' do
    <<~RUBY
      # remember to create service file on vm if needed
      # https://github.com/mperham/sidekiq/wiki/Deployment
      redis_conn = proc {
        Redis.new url: "#{ENV.fetch('REDIS_URL') {'redis://localhost:6379'}}/2"
      }
      ActiveJob::TrafficControl.client = ConnectionPool.new(size: 5, timeout: 5, &redis_conn)
      Sidekiq.configure_client do |config|
        config.redis = ConnectionPool.new(size: 5, &redis_conn)
        config.client_middleware do |chain|
          chain.add SidekiqUniqueJobs::Middleware::Client
          chain.add Sidekiq::Status::ClientMiddleware, expiration: 7.days
        end
      end

      Sidekiq.configure_server do |config|
        config.redis = ConnectionPool.new(size: 25, &redis_conn)
        config.log_formatter = ::Logger::Formatter.new
        config.failures_max_count = 10_000
        config.failures_default_mode = :exhausted
        config.client_middleware do |chain|
          chain.add SidekiqUniqueJobs::Middleware::Client
          chain.add Sidekiq::Status::ClientMiddleware, expiration: 7.days
        end
        config.server_middleware do |chain|
          chain.add Sidekiq::Status::ServerMiddleware, expiration: 7.days
          chain.add SidekiqUniqueJobs::Middleware::Server
        end
        SidekiqUniqueJobs::Server.configure(config)
      end
    RUBY
  end

  inject_into_class 'app/jobs/application_job.rb', 'ApplicationJob' do
    <<~RUBY
      include Sidekiq::Status::Worker
    RUBY
  end
end

def custom_routes
  prepend_file 'config/routes.rb' do
    <<~RUBY
      require 'sidekiq-scheduler/web'
      require 'sidekiq-status/web'
    RUBY
  end
  route "mount Sidekiq::Web => '/sidekiq'"
end

def custom_yml
  add_file 'config/sidekiq.yml' do
    <<~YML
      :concurrency: 20
      :pidfile: tmp/pids/sidekiq-0.pid
      :logfile: log/sidekiq.log
      :queues:
        - default
        - mailers
    YML
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
