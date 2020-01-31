# frozen_string_literal: true

def setup_rollbar
  rollbar_key = ask('input rollbar_key, or [n] to skip rollbar setup:')
  return unless rollbar_key.present? && %w[n no].exclude?(rollbar_key.downcase)

  rollbar_gems
  after_bundle do
    generate "rollbar #{rollbar_key}"
  end
end

private

def rollbar_gems
  gem 'rollbar', group: %i[production development]
end
