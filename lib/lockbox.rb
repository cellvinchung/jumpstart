# frozen_string_literal: true

def setup_lockbox
  lockbox_gems

  after_bundle do
    initializer 'lockbox.rb' do
      <<~RUBY
        Lockbox.master_key = Rails.application.credentials.dig(Rails.env.to_sym, :lockbox_master_key)
      RUBY
    end
  end
end

private

def lockbox_gems
  gem 'lockbox', '~> 0.3.3'
  gem 'blind_index', '~> 2.0', '>= 2.0.1'
  gem 'kms_encrypted', '~> 1.1'
end
