def setup_flipper
  flipper_gems
  after_bundle do
    generate 'flipper:active_record'
    initializer 'flipper.rb' do
      <<~RUBY
        Flipper.configure do |config|

        end

        Flipper::UI.configure do |config|
          config.fun = false
          # config.banner_text = ""
          # config.banner_class = ''
        end
      RUBY
    end

    route "mount Flipper::Api.app(Flipper) => '/flipper/api'"
    route "mount Flipper::UI.app(Flipper) => '/flipper'"
  end
end

def flipper_gems
  gem_group :production, :development, :staging do
    gem 'flipper', '~> 0.22.2'
    gem 'flipper-active_record', '~> 0.22.2'
    gem 'flipper-ui', '~> 0.22.2'
    gem 'flipper-api', '~> 0.22.2'
  end
end
