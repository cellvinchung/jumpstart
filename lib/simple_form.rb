# frozen_string_literal: true

def setup_simple_form
  simple_form_gems

  after_bundle do
    generate 'simple_form:install --bootstrap'
  end
end

private

def simple_form_gems
  gem 'simple_form'
end
