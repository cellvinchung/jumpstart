# frozen_string_literal: true

def setup_letter_opener
  letter_opener_gems

  after_bundle do
    content = <<~RUBY
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = true
      config.action_mailer.default_url_options = { host: 'lvh.me', port: 3000 }
    RUBY

    environment "#{content}\n", env: 'development'
  end
end

private

def letter_opener_gems
  gem 'letter_opener', '~> 1.7', group: %i[development]
end
