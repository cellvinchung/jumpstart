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
    gem 'sidekiq', '>= 6'
    gem 'sidekiq-statistic', git: 'https://github.com/davydovanton/sidekiq-statistic.git'
    gem 'sidekiq-cron', '~> 1.1'
    gem 'sidekiq-unique-jobs'
    gem 'sidekiq-status'
    gem 'activejob-traffic_control'
  end
end

def custom_sidekiq
  initializer 'sidekiq.rb' do
    <<~RUBY
      redis_conn = proc {
        Redis.new host: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host), port: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port)
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
    RUBY
  end
  route "mount Sidekiq::Web => '/sidekiq'"
end

def custom_yml
  add_file 'config/sidekiq.yml' do
    <<~YML
      :concurrency: 2
      :pidfile: tmp/pids/sidekiq-0.pid
      :logfile: log/sidekiq.log
      :queues:
        - default
        - mailers
    YML
  end
end
