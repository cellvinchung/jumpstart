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
  gem_group :production, :development, :staging do
    gem 'pry-rails', '~> 0.3.9'
    gem 'pry-byebug', '~> 3.9'
    gem 'pry-stack_explorer', '~> 0.6.1'
    gem 'amazing_print', '~> 1.4', require: false
  end
end

def custom_pryrc
  add_file '.pryrc' do
    <<~RUBY
      require "amazing_print"
      AmazingPrint.pry!
      if Pry::Prompt[:rails]
        Pry.config.prompt = Pry::Prompt[:rails]
      end
    RUBY
  end
end
