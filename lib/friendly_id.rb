# frozen_string_literal: true

def setup_friendly_id
  friendly_id_gems

  after_bundle do
    generate 'friendly_id'
  end
end

private

def friendly_id_gems
  gem 'friendly_id', '~> 5.2', '>= 5.2.5'
  gem 'babosa', '~> 1.0', '>= 1.0.3'
end
