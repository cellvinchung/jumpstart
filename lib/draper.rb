# frozen_string_literal: true

def setup_draper
  draper_gems

  after_bundle do
    generate 'draper:install'

    inject_into_class 'app/decorators/application_decorator.rb', 'ApplicationDecorator' do
      <<-RUBY
        include Draper::LazyHelpers
        include ActionView::Helpers::UrlHelper
      RUBY
    end
  end
end

private

def draper_gems
  gem 'draper'
end
