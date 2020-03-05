# frozen_string_literal: true

require "../#{$jumpstart_folder}/webpack/bootstrap"
require "../#{$jumpstart_folder}/webpack/data_confirm_modal"
require "../#{$jumpstart_folder}/webpack/flatpickr"
require "../#{$jumpstart_folder}/webpack/fontawesome"
require "../#{$jumpstart_folder}/webpack/local_time"
require "../#{$jumpstart_folder}/webpack/noty"
require "../#{$jumpstart_folder}/webpack/uppy"

def setup_webpack
  after_bundle do
    run 'yarn add --dev expose-loader jquery @popperjs/core bootstrap \
    data-confirm-modal flatpickr local-time i18n-js @fortawesome/fontawesome-free \
    noty axios @uppy/core @uppy/dashboard @uppy/status-bar https://github.com/excid3/uppy-activestorage-upload.git @fullhuman/postcss-purgecss'
    create_stylesheet
    custom_webpack_env
    custom_application_pack
    setup_purgecss

    setup_plugins
  end
end

private

def create_stylesheet
  add_file 'app/javascript/stylesheets/custom.scss'
  add_file 'app/javascript/stylesheets/application.scss' do
    <<~CSS
      @import "custom";
    CSS
  end
  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      import "../stylesheets/application";
    JAVASCRIPT
  end

  gsub_file 'app/views/layouts/application.html.erb', 'stylesheet_link_tag', 'stylesheet_pack_tag'
end

def custom_webpack_env
  insert_into_file 'config/webpack/environment.js', before: 'module.exports = environment' do
    <<~JAVASCRIPT
      const webpack = require('webpack');
      environment.plugins.append('Provide', new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Rails: '@rails/ujs'
      }));
    JAVASCRIPT
  end
end

def custom_application_pack
  add_file 'app/javascript/packs/custom.js'
  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      window.jQuery = $
      window.$ = $
      window.Rails = Rails
      import axios from 'axios';
      import "./custom";
    JAVASCRIPT
  end
end

def setup_purgecss
  prepend_file 'postcss.config.js' do
    <<~JAVASCRIPT
      const purgecss = require('@fullhuman/postcss-purgecss')({
        content: [
          './src/**/*.html.*',
          './src/**/*.vue',
          './src/**/*.jsx',
          // etc.
        ],
        defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
      });
    JAVASCRIPT
  end

  insert_into_file 'postcss.config.js', after: 'plugins: [\n' do
    <<~JAVASCRIPT
      ...process.env.NODE_ENV === 'production' ? [purgecss] : [],\n
    JAVASCRIPT
  end
end

def setup_plugins
  setup_bootstrap
  setup_fontawesome
  setup_flatpickr
  setup_localtime
  setup_data_confirm_modal
  setup_noty
  setup_uppy
end
