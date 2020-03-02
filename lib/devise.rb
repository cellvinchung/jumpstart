# frozen_string_literal: true

require "../#{$jumpstart_folder}/pundit"

def setup_devise
  devise_model = ask('input the model name for devise, or [n] to skip devise setup:')
  return unless devise_model.present? && %w[n no].exclude?(devise_model.downcase)

  devise_gems

  after_bundle do
    generate 'devise:install'
    generate 'devise', devise_model
    generate "devise:i18n:views #{devise_model}"
    generate 'devise:i18n:locale zh-TW'
    set_omniauth
  end

  setup_pundit
end

private

def devise_gems
  gem 'devise', '~> 4.7', '>= 4.7.0'
  gem 'devise-i18n', '~> 1.9'
  gem 'omniauth-google-oauth2', '~> 0.8.0'
  gem 'omniauth-facebook', '~> 6.0'
  gem 'omniauth-twitter', '~> 1.4'
  gem 'omniauth-line', git: 'git@github.com:chrislintw/omniauth-line.git'
end

def set_omniauth
  inject_into_class 'app/models/user.rb', 'User' do
    <<~RUBY
      has_many :oauth_providers, dependent: :destroy
      devise :omniauthable, omniauth_providers: [:google, :facebook, :twitter, :line]
    RUBY
  end
  generate 'model oauth_provider user:references provider:string uid:string:index expires_at:datetime access_token:string access_token_secret:string refresh_token:string auth:text'
  inject_into_class 'app/models/oauth_provider.rb', 'OauthProvider' do
    <<~RUBY
      validates :uid, :provider, presence: true
      validates :uid, uniqueness: { scope: :provider }
    RUBY
  end
  devise_omniauth
end

def devise_omniauth
  insert_into_file 'config/initializers/devise.rb', after: "# ==> OmniAuth\n" do
    <<~RUBY
      config.omniauth :google_oauth2, Rails.application.credentials.dig(Rails.env.to_sym, :google, :client_id), Rails.application.credentials.dig(Rails.env.to_sym, :google, :client_secret), {
        name: 'google'
      }
      config.omniauth :facebook, Rails.application.credentials.dig(Rails.env.to_sym, :facebook, :app_id), Rails.application.credentials.dig(Rails.env.to_sym, :facebook, :secret),{
        secure_image_url: true
      }
      config.omniauth :twitter, Rails.application.credentials.dig(Rails.env.to_sym, :twitter, :api_key), Rails.application.credentials.dig(Rails.env.to_sym, :twitter, :api_secret), {
        secure_image_url: true
      }
      config.omniauth :line, Rails.application.credentials.dig(Rails.env.to_sym, :line, :channel_id), Rails.application.credentials.dig(Rails.env.to_sym, :line, :channel_secret), {
      }
    RUBY
  end
end