# frozen_string_literal: true

def setup_lockbox
  lockbox_gems

  after_bundle do
    initializer 'lockbox.rb' do
      <<~RUBY
        Lockbox.master_key = Rails.application.credentials.dig(:lockbox, :master_key)
      RUBY
    end
  end
end

private

def lockbox_gems
  gem 'lockbox', '~> 0.6.1'
  gem 'blind_index', '~> 2.2'
  gem 'kms_encrypted', '~> 1.2', '>= 1.2.1'
end
