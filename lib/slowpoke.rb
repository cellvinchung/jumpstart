# frozen_string_literal: true

def setup_slowpoke
  slowpoke_gems
  after_bundle do
    custom_slowpoke

    environment 'config.consider_all_requests_local = false', env: 'development'
  end
end

private

def slowpoke_gems
  gem 'slowpoke', group: %i[production development]
end

def custom_slowpoke
  initializer 'slowpoke.rb' do
    <<~RUBY
      Slowpoke.on_timeout do |env|
        next if Rails.env.development? || Rails.env.test?

        exception = env['action_dispatch.exception']
        if exception && exception.backtrace.first.include?('/active_record/')
          Slowpoke.kill
        end
      end
    RUBY
  end
end
