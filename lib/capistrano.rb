# frozen_string_literal: true

def setup_capistrano
  capistrano_gems

  after_bundle do
    run 'cap install'

    custom_capfile
    custom_deploy
    set_staging
  end
end

private

def capistrano_gems
  gem_group :development do
    gem 'capistrano-rails', require: false
    gem 'rvm1-capistrano3', require: false
    gem 'capistrano-passenger', require: false
    gem 'capistrano-upload-config', require: false
  end
end

def custom_capfile
  insert_into_file 'Capfile', after: "require \"capistrano/deploy\"\n" do
    <<~RUBY
      require 'capistrano/rails'
      require 'capistrano/passenger'
      require 'capistrano/upload-config'
    RUBY
  end
end

def custom_deploy
  append_file 'config/deploy.rb' do
    <<~RUBY
      append :linked_files, 'config/database.yml', 'config/master.key',
         'config/storage.yml', 'config/gcs.json', 'config/sidekiq.yml', '.env'

      append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system',
       'public/packs', '.bundle', 'node_modules', 'data'

      before 'deploy:check:linked_files', 'config:push'
    RUBY
  end
end

def set_staging
  append_file 'config/deploy/staging.rb' do
    <<~RUBY
      set :rails_env, 'production'
    RUBY
  end
end
