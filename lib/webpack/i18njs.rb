def setup_i18njs
  file 'app/frontend/i18n/index.js.erb' do
    <<-ERB
      import I18n from "i18n-js"
      I18n.translations = <%= I18n::JS.filtered_translations.to_json %>;
      export default I18n
    ERB
  end

  append_file 'app/frontend/packs/application.js' do
    <<~JAVASCRIPT
      import I18n from 'i18n/index.js.erb'
      I18n.locale = gon.locale;
      I18n.defaultLocale = gon.default_locale;
      window.I18n = I18n;
    JAVASCRIPT
  end
end
