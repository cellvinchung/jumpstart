# frozen_string_literal: true

def setup_draper
  draper_gems

  after_bundle do
    generate 'draper:install'

    inject_into_class 'app/decorators/application_decorator.rb', 'ApplicationDecorator' do
      <<-RUBY
      include Draper::LazyHelpers
      include ActionView::Helpers::UrlHelper
      include Rails.application.routes.url_helpers

      def created_at
        object.created_at.strftime('%F %R')
      end

      def updated_at
        object.updated_at.strftime('%F %R')
      end
      RUBY
    end
  end
end

private

def draper_gems
  gem 'draper', '~> 4.0', '>= 4.0.2'
end
