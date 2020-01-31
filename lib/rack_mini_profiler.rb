# frozen_string_literal: true

def setup_rack_mini_profiler
  rack_mini_profiler_gems

  after_bundle do
    generate 'rack_profiler:install'
  end
end

private

def rack_mini_profiler_gems
  gem_group :development do
    gem 'rack-mini-profiler', require: false
    gem 'memory_profiler'
    gem 'flamegraph'
    gem 'stackprof'
    gem 'fast_stack'
  end
end
