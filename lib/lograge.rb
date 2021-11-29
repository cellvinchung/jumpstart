# frozen_string_literal: true

def setup_lograge
  lograge_gems

  after_bundle do
    cunstom_lograge
    add_payload
  end
end

private

def lograge_gems
  gem 'lograge', '~> 0.11.2'
end

def cunstom_lograge
  content = <<~RUBY
    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      options = event.payload.slice(:request_id, :user_id)
      options[:params] = event.payload[:params].except("controller", "action")
      options
    end
  RUBY
  environment "#{content}\n", env: 'production'
end

def add_payload
  inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
    <<-RUBY
      def append_info_to_payload(payload)
        super
        payload[:request_id] = request.uuid
        payload[:user_id] = current_user.id if current_user
      end
    RUBY
  end
end
