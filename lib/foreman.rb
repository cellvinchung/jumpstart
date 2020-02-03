# frozen_string_literal: true

def setup_foreman
  add_file 'Procfile' do
    <<~CODE
      rails: rails s -p 3000
      webpack: bin/webpack-dev-server
      sidekiq: sidekiq
    CODE
  end
end
