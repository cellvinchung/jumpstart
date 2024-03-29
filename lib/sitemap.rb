# frozen_string_literal: true

def setup_sitemap
  sitemap_gems

  after_bundle do
    append_file 'Capfile' do
      <<~RUBY
        require 'capistrano/sitemap_generator'
      RUBY
    end
    rake 'sitemap:install'
  end
end

private

def sitemap_gems
  gem 'sitemap_generator', '~> 6.1', '>= 6.1.2', require: false, group: %i[development production staging]
end
