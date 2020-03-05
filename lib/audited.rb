# frozen_string_literal: true

def setup_audited
  audited_gems

  after_bundle do
    generate 'audited:install --audited-changes-column-type jsonb'
  end
end

private

def audited_gems
  gem 'audited', '~> 4.9'
end
