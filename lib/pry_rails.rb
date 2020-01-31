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
    gem 'pry-rails'
    gem 'hirb'
    gem 'hirb-unicode-steakknife'
    gem 'pry-byebug'
    gem 'pry-stack_explorer'
    gem 'awesome_rails_console', require: false
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
