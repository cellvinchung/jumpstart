# frozen_string_literal: true

def setup_pghero
  return unless yes?('using postgresql? [y/N]')

  pghero_gems

  after_bundle do
    route "mount PgHero::Engine, at: 'pghero'"
    generate 'pghero:config'
    generate 'pghero:query_stats'
    generate 'pghero:space_stats'
  end
end

private

def pghero_gems
  gem 'pghero'
  gem 'pg_query', '>= 0.9.0'
end
