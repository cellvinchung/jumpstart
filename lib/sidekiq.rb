# frozen_string_literal: true

def setup_sidekiq
  sidekiq_gems

  after_bundle do
    application 'config.active_job.queue_adapter = :sidekiq'
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
    YML
  end
end
