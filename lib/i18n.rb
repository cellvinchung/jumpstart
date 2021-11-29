# frozen_string_literal: true

def setup_i18n
  i18n_gems

  after_bundle do
    initializer 'i18n_active_record.rb' do
      initializer_i18n_content
    end
    application do
      <<~RUBY
        config.middleware.use I18n::JS::Middleware
      RUBY
    end

    append_file 'Rakefile' do
      <<~RUBY
        require 'i18n-spec/tasks'
      RUBY
    end

    locale_content
  end
end

private

def initializer_i18n_content
  <<~RUBY
    require 'i18n/backend/active_record'
    I18n::Backend::ActiveRecord.configure do |config|
      config.cleanup_with_destroy = true # defaults to false
      config.cache_translations = true # defaults to false
    end
  RUBY
end

def locale_content
  file 'config/locales/zh-TW.yml' do
    <<~YML
    zh-TW:
      back: '返回'
      cancel: '取消'
      confirm_action: '你確定嗎？'
      created_at: '建立時間'
      destroy: '刪除'
      edit: '編輯'
      error: '發生錯誤'
      internal_server_error: '伺服器錯誤'
      login: '登入'
      logout: '登出'
      new: '新增'
      not_authorized: '沒有權限'
      not_found: '頁面不存在'
      service_unavailable: '連線逾時'
      show: '檢視'
      submit: '送出'
      updated_at: '更新時間'
      unprocessable_entity: '存取被拒'
      true: '是'
      false: '否'
    YML
  end

  file 'config/locales/versions/zh-TW.yml' do
    <<~YML
    zh-TW:
      activerecord:
        attributes:
          version:
            event: '事件'
            item_type: '異動項目'
            object_changes: 內容
            created_at: '異動時間'
            whodunnit: '執行人'
        models:
          version: '版本紀錄'
      simple_form:
        options:
          version:
            event:
              create: '建立'
              update: '更新'
              destroy: '刪除'
    YML
  end
end

def i18n_gems
  gem 'rails-i18n', '~> 6.0'
  gem 'i18n-js', '~> 3.9'
  gem 'i18n-active_record', '~> 1.0', '>= 1.0.1'
  gem_group :development, :test do
    gem 'i18n-spec', github: 'tigrish/i18n-spec'
  end
end
