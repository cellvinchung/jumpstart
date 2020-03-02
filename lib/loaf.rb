# frozen_string_literal: true

def setup_loaf
  loaf_gems

  after_bundle do
    generate 'loaf:install'
  end
end

private

def loaf_gems
  gem 'loaf', '~> 0.9.0'
end
