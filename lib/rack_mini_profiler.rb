# frozen_string_literal: true

def setup_rack_mini_profiler
  rack_mini_profiler_gems

  after_bundle do
    generate 'rack_profiler:install'
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
    gem 'rack-mini-profiler'
    gem 'memory_profiler'
    gem 'flamegraph'
    gem 'stackprof'
    gem 'fast_stack'
  end
end
