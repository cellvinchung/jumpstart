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
  end
end

private

def whenever_gems
  gem 'whenever', require: false, group: %i[development production]
end
