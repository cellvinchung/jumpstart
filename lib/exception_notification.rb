# frozen_string_literal: true

def setup_exception_notification
  exception_notification_gems

  after_bundle do
    initializer 'exception_notification.rb' do
      <<~RUBY
      require 'exception_notification/sidekiq'
      ExceptionNotification.configure do |config|
        config.ignore_if do |_exception, _options|
          Rails.env.development?
        end
        config.add_notifier(
          :slack,
          webhook_url: Rails.application.credentials.dig(:slack, :webhook_url),
          ignore_crawlers: %w[Googlebot bingbot],
          additional_parameters: {
            mrkdwn: true
          }
        )
      end
      RUBY
    end
  end
end

private

def exception_notification_gems
  gem 'exception_notification'
  gem 'slack-notifier'
end
