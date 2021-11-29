# frozen_string_literal: true

def setup_pundit
  pundit_gems

  after_bundle do
    inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
      <<~RUBY
        include Pundit
        rescue_from Pundit::NotAuthorizedError, with: :not_authorized

        def not_authorized
          flash[:error] = t('not_authorized')
          redirect_back(fallback_location: root_path)
        end
      RUBY
    end
    generate 'pundit:install'
    application "config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden"
  end
end

private

def pundit_gems
  gem 'pundit', '~> 2.1', '>= 2.1.1'
end
