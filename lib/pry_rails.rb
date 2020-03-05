# frozen_string_literal: true

def setup_pry_rails
  pry_gems

  after_bundle do
    application 'config.console = Pry'
    custom_pryrc
  end
end

private

def pry_gems
  gem_group :production, :development do
    gem 'pry-rails', '~> 0.3.9'
    gem 'hirb', '~> 0.7.3'
    gem 'hirb-unicode-steakknife', '~> 0.0.9'
    gem 'pry-byebug', '~> 3.8'
    gem 'pry-stack_explorer', '~> 0.4.9.3'
    gem 'awesome_rails_console', '~> 0.4.4', require: false
  end
end

def custom_pryrc
  add_file '.pryrc' do
    <<~RUBY
      require "awesome_rails_console"
      AwesomePrint.pry!
      if Pry::Prompt[:rails]
        Pry.config.prompt = Pry::Prompt[:rails][:value]
      end
    RUBY
  end
end
