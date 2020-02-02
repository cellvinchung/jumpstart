# frozen_string_literal: true

def setup_sitemap
  sitemap_gems

  after_bundle do
    rails_command 'sitemap:install'

    append_file 'Capfile' do
      <<~RUBY
        require 'capistrano/sitemap_generator'
      RUBY
    end
  end
end

private

def sitemap_gems
  gem 'sitemap_generator', group: %i[development production]
end
