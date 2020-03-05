# frozen_string_literal: true

def setup_i18n
  i18n_gems

  after_bundle do
    generate 'model I18nTranslation locale:string:index key:string:index value:text interpolations:text is_proc:boolean'
    initializer 'i18n_active_record.rb' do
      initializer_content
    end
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

def i18n_gems
  gem 'rails-i18n', '~> 6.0'
  gem 'i18n-js', '~> 3.6'
  gem 'i18n-active_record', '~> 0.4.0', require: 'i18n/active_record'
end
