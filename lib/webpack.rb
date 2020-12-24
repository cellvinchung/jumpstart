# frozen_string_literal: true

require_relative 'webpack/bootstrap'
require_relative 'webpack/dayjs'
require_relative 'webpack/flatpickr'
require_relative 'webpack/fontawesome'
require_relative 'webpack/i18njs'
require_relative 'webpack/local_time'
require_relative 'webpack/noty'
require_relative 'webpack/sweetalert'
require_relative 'webpack/tippy'

def setup_webpack
  after_bundle do
    rails_command 'webpacker:install:erb'
    run 'yarn add expose-loader bootstrap @popperjs/core \
    sweetalert2 flatpickr local-time i18n-js @fortawesome/fontawesome-free \
    noty axios lodash dayjs tippy.js resolve-url-loader'
    custom_application_pack
    create_stylesheet
    custom_webpack_env

    setup_plugins
  end
end

private

def create_stylesheet
  file 'app/frontend/stylesheets/custom.scss'
  file 'app/frontend/stylesheets/application.scss' do
    <<~CSS
      @import url("https://fonts.googleapis.com/css?family=Noto+Sans+TC:400,500,700,900&display=swap");
      * {
        font-family: "Noto Sans TC", sans-serif;
      }
      @import "custom";
    CSS
  end
  append_file 'app/frontend/packs/application.js' do
    <<~JAVASCRIPT

      import "../stylesheets/application";
    JAVASCRIPT
  end

  gsub_file 'app/views/layouts/application.html.erb', 'stylesheet_link_tag', 'stylesheet_packs_with_chunks_tag'
  gsub_file 'app/views/layouts/application.html.erb', 'javascript_pack_tag', 'javascript_packs_with_chunks_tag'
end

def custom_webpack_env
  insert_into_file 'config/webpack/environment.js', before: 'module.exports = environment' do
    <<~JAVASCRIPT
      environment.splitChunks();
      const webpack = require('webpack');
      environment.plugins.append('Provide', new webpack.ProvidePlugin({
        Rails: '@rails/ujs',
        _: 'lodash',
        axios: 'axios'
      }));
      environment.loaders.get("sass").use.splice(-1, 0, {
        loader: "resolve-url-loader",
      });
    JAVASCRIPT
  end

  gsub_file 'config/webpack.yml', 'app/javascripts', 'app/frontend'
end

def custom_application_pack
  run 'mv app/javacript app/frontend'
  run 'mkdir app/images'

  file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./tippy";

    JAVASCRIPT
  end
  append_file 'app/frontend/packs/application.js' do
    <<~JAVASCRIPT
      const images = require.context("../images", true)
      const imagePath = (name) => images(name, true)

      window.Rails = Rails
      import "../javascripts";
    JAVASCRIPT
  end
end

def setup_plugins
  setup_i18njs
  setup_dayjs
  setup_bootstrap
  setup_fontawesome
  setup_flatpickr
  setup_localtime
  setup_noty
  setup_sweetalert
  setup_tippy
  # setup_uppy
end
