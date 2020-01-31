# frozen_string_literal: true

require 'webpack/bootstrap'
require 'webpack/data_confirm_modal'
require 'webpack/flatpickr'
require 'webpack/fontawesome'
require 'webpack/local_time'
require 'webpack/noty'

def setup_webpack
  after_bundle do
    run 'yarn add --dev expose-loader jquery popper.js bootstrap \
    data-confirm-modal flatpickr local-time i18n-js @fortawesome/fontawesome-free \
    noty axios'
    create_stylesheet
    custom_webpack_env
    custom_application_pack

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

def setup_plugins
  setup_bootstrap
  setup_fontawesome
  setup_flatpickr
  setup_localtime
  setup_data_confirm_modal
  setup_noty
end
