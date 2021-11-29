def setup_better_errors
  better_errors_gem
  after_bundle do
    content = <<~RUBY
      config.after_initialize do
        BetterErrors::Middleware.allow_ip!(HTTP.get('https://ipecho.net/plain').to_s)
      end
    RUBY

    environment "#{content}\n", env: 'development'
  end
end

def better_errors_gem
  gem_group :development do
    gem 'better_errors', '~> 2.9', '>= 2.9.1'
    gem 'binding_of_caller', '~> 1.0'
  end
end
