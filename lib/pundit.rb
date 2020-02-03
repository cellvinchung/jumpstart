# frozen_string_literal: true

def setup_pundit
  pundit_gems

  after_bundle do
    inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
      <<~RUBY
        include Pundit
      RUBY
    end
    generate 'pundit:install'
  end
end

private

def pundit_gems
  gem 'pundit'
end
