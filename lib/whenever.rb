# frozen_string_literal: true

def setup_whenever
  whenever_gems

  after_bundle do
    run 'wheneverize .'
    append_file 'Capfile' do
      <<~RUBY
        require 'whenever/capistrano'
      RUBY
    end

    append_file 'config/schedule.rb' do
      <<~RUBY
        set :chronic_options, hours24: true
      RUBY
    end
  end
end

private

def whenever_gems
  gem 'whenever', '~> 1.0', require: false, group: %i[development production staging]
end
