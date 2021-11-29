# frozen_string_literal: true

def update_gitignore
  append_file '.gitignore' do
    <<~CODE
      # settings
      config/database.yml
      config/storage.yml
      config/*.json
      .env*

      # deploy
      config/deploy/*.rb
      config/deploy/templates/*

      # db schema.rb
      db/schema.rb

      erd.pdf

      .vscode/*
      app/data/*
      data/*
      storage/*
    CODE
  end
end
