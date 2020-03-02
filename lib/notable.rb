# frozen_string_literal: true

def setup_notable
  notable_gems

  after_bundle do
    generate 'notable:requests'
    generate 'notable:jobs'
    initializer 'notable.rb' do
      <<~RUBY
        Notable.enabled = Rails.env.production?
      RUBY
    end
  end
end

private

def notable_gems
  gem 'notable', '~> 0.3.0'
end
