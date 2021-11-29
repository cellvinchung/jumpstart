# frozen_string_literal: true

def setup_loaf
  loaf_gems

  after_bundle do
    initializer 'loaf.rb' do
      <<~RUBY
        Loaf.configure do |config|
          config.match = :exclusive
        end
      RUBY
    end
  end
end

private

def loaf_gems
  gem 'loaf', '~> 0.10.0'
end
