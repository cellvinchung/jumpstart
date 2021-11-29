# frozen_string_literal: true

def setup_rack_mini_profiler
  rack_mini_profiler_gems
end

private

def rack_mini_profiler_gems
  gem_group :development do
    gem 'memory_profiler', '~> 1.0'
    gem 'flamegraph', '~> 0.9.5'
    gem 'stackprof', '~> 0.2.17'
    gem 'fast_stack', '~> 0.2.0'
  end
end
