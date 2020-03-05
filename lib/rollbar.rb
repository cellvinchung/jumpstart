# frozen_string_literal: true

def setup_rollbar
  return unless yes?('using rollbar? [y/N]')

  rollbar_gems
  after_bundle do
    generate "rollbar"
    append_file 'Capfile' do
      <<~RUBY
        require 'rollbar/capistrano'
      RUBY
    end

    append_file 'config/deploy.rb' do
      <<~RUBY
        set :rollbar_token, 'POST_SERVER_ITEM_ACCESS_TOKEN'
        set :rollbar_env, Proc.new { fetch :stage }
        set :rollbar_role, Proc.new { :app }
      RUBY
    end
  end
end

private

def rollbar_gems
  gem 'rollbar', '~> 2.24', group: %i[production development]
end
