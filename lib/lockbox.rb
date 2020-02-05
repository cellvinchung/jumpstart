# frozen_string_literal: true

def setup_lockbox
  lockbox_gems

  after_bundle do
    initializer 'lockbox.rb' do
      <<~RUBY
        pending 'add lockbox_master_key to credentials'
        Lockbox.master_key = Rails.application.credentials.dig(Rails.env.to_sym, :lockbox_master_key)
      RUBY
    end
  end
end

private

def lockbox_gems
  gem 'lockbox'
  gem 'blind_index'
  gem 'kms_encrypted'
end
