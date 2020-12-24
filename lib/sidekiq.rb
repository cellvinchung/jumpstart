# frozen_string_literal: true

def setup_sidekiq
  sidekiq_gems

  after_bundle do
    application 'config.active_job.queue_adapter = :sidekiq'
    custom_sidekiq
    custom_routes
    custom_yml
  end
end

private

def sidekiq_gems
  gem_group :production, :development do
    gem 'sidekiq', '~> 6.1', '>= 6.1.2'
    gem 'sidekiq-statistic', '~> 1.4'
    gem 'sidekiq-scheduler', '~> 3.0', '>= 3.0.1'
    gem 'sidekiq-status', '~> 1.1', '>= 1.1.4'
    gem 'activejob-traffic_control', '~> 0.1.3'
  end
end

def custom_sidekiq
  initializer 'sidekiq.rb' do
    <<~RUBY
      # remember to create service file on vm if needed
      # https://github.com/mperham/sidekiq/wiki/Deployment
      redis_conn = proc {
        Redis.new url: "#{ENV.fetch('REDIS_URL')}/2"
      }
      ActiveJob::TrafficControl.client = ConnectionPool.new(size: 5, timeout: 5, &redis_conn)
      Sidekiq.configure_client do |config|
        config.redis = ConnectionPool.new(size: 5, &redis_conn)
      end

      Sidekiq.configure_server do |config|
        config.redis = ConnectionPool.new(size: 25, &redis_conn)
      end
    RUBY
  end
end

def custom_routes
  prepend_file 'config/routes.rb' do
    <<~RUBY
      require 'sidekiq/web'
      require 'sidekiq-status/web'
      require 'sidekiq-scheduler/web'
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
