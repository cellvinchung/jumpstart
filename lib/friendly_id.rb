# frozen_string_literal: true

def setup_friendly_id
  friendly_id_gems

  after_bundle do
    generate 'friendly_id'
    uncomment_lines 'config/initializers/friendly_id.rb', 'config.use :slugged'
  end
end

private

def friendly_id_gems
  gem 'friendly_id', '~> 5.4', '>= 5.4.2'
  gem 'babosa', '~> 2.0'
end
