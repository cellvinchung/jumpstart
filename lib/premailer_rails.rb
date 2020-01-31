# frozen_string_literal: true

def setup_premailer
  premailer_gems
  after_bundle do
    initializer 'premailer_rails.rb' do
      <<~RUBY
        Premailer::Rails.config.merge!(preserve_styles: true, remove_ids: true, input_encoding: 'UTF-8')
      RUBY
    end
  end
end

private

def premailer_gems
  gem 'premailer-rails'
end
