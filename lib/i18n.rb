# frozen_string_literal: true

def setup_i18n
  i18n_gems

  after_bundle do
    generate 'model I18nTranslation locale:string:index key:string:index value:text interpolations:text is_proc:boolean'
    generate 'i18n:js:config'
    initializer 'i18n_active_record.rb' do
      initializer_content
    end
    application do
      <<~RUBY
        config.middleware.use I18n::JS::Middleware
      RUBY
    end

    locale_content
  end
end

private

def initializer_content
  <<~RUBY
    require 'i18n/backend/active_record'

    Translation  = I18n::Backend::ActiveRecord::Translation

    if Translation.table_exists?
      I18n.backend = I18n::Backend::ActiveRecord.new

      I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
      I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
      I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

      I18n.backend = I18n::Backend::Chain.new(I18n::Backend::Simple.new, I18n.backend)
    end

    I18n::Backend::ActiveRecord.configure do |config|
      config.cleanup_with_destroy = true # defaults to false
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
      login: '登入'
      logout: '登出'
      new: '新增'
      show: '檢視'
      submit: '送出'
      updated_at: '更新時間'
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
        labels:
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
  gem 'i18n-js', '~> 3.8'
  gem 'i18n-active_record', '~> 0.4.0', require: 'i18n/active_record'
end
