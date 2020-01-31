# frozen_string_literal: true

def setup_letter_opener
  letter_opener_gems

  after_bundle do
    environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'
    environment 'config.action_mailer.perform_deliveries = true', env: 'development'
    environment "config.action_mailer.default_url_options = { host: 'lvh.me', port: 3000 }", env: 'development'
  end
end

private

def letter_opener_gems
  gem 'letter_opener', group: %i[development]
end
