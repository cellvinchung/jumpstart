# frozen_string_literal: true

def setup_cloudflare
  return unless yes?('using cloudflare? [y/N]')

  gem 'cloudflare-rails', group: %i[production]
end
