# frozen_string_literal: true

def setup_rack_mini_profiler
  rack_mini_profiler_gems

  after_bundle do
    initializer 'rack_mini_profiler.rb' do
      <<~RUBY
        if Rails.env.development?
          require 'rack-mini-profiler'
          Rack::MiniProfilerRails.initialize!(Rails.application)
          Rails.application.middleware.delete(Rack::MiniProfiler)
          Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
        end
      RUBY
    end
  end
end

private

def rack_mini_profiler_gems
  gem_group :development do
    gem 'rack-mini-profiler', '~> 1.1', '>= 1.1.6', require: false
    gem 'memory_profiler', '~> 0.9.14'
    gem 'flamegraph', '~> 0.9.5'
    gem 'stackprof', '~> 0.2.15'
    gem 'fast_stack', '~> 0.2.0'
  end
end
