# frozen_string_literal: true

def setup_devise
  devise_model = ask('input the model name for devise, or [n] to skip devise setup:')
  return unless devise_model.present? && %w[n no].exclude?(devise_model.downcase)

  devise_gems

  after_bundle do
    generate 'devise:install'
    generate 'devise', devise_model
    generate "devise:i18n:views #{devise_model}"
    generate 'devise:i18n:locale zh-TW'

  end
end

private

def devise_gems
  gem 'devise', '~> 4.7', '>= 4.7.0'
  gem 'devise-i18n'
  gem 'omniauth-google-oauth2'
  gem 'omniauth-facebook'
  gem 'omniauth-twitter'
  gem 'omniauth-line', git: 'git@github.com:chrislintw/omniauth-line.git'
end
