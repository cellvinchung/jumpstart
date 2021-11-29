# frozen_string_literal: true

require_relative 'webpack/bootstrap'
require_relative 'webpack/dayjs'
require_relative 'webpack/flatpickr'
require_relative 'webpack/fontawesome'
require_relative 'webpack/i18njs'
require_relative 'webpack/local_time'
require_relative 'webpack/pnotify'
require_relative 'webpack/sweetalert'
require_relative 'webpack/tippy'

def setup_webpack
  after_bundle do
    rails_command 'webpacker:install:erb'
    run 'rm -r app/javascript/packs/hello_erb.js.erb'
    run 'yarn add expose-loader bootstrap popper.js \
    sweetalert2 @sweetalert2/theme-bootstrap-4 flatpickr local-time i18n-js \
    axios lodash dayjs tippy.js resolve-url-loader json-loader \
    @fortawesome/fontawesome-svg-core @fortawesome/free-solid-svg-icons @fortawesome/free-regular-svg-icons @fortawesome/free-brands-svg-icons \
    @pnotify/core @pnotify/desktop @pnotify/mobile @pnotify/countdown @pnotify/font-awesome5-fix @pnotify/font-awesome5'

    run 'yarn add speed-measure-webpack-plugin webpack-bundle-analyzer -D'

    custom_webpack_env
    setup_lib_pack
    setup_plugins
  end
end

private

def custom_webpack_env
  insert_into_file 'config/webpack/environment.js', before: 'module.exports = environment' do
    <<~JAVASCRIPT
      environment.splitChunks();
      const webpack = require('webpack');
      environment.plugins.append('Provide', new webpack.ProvidePlugin({
        Rails: '@rails/ujs',
        lodash: 'lodash'
      }));
      environment.loaders.get("sass").use.splice(-1, 0, {
        loader: "resolve-url-loader",
      });

      const jsonLoader = {
        test: /\.json$/,
        use: 'json-loader'
      };
      environment.loaders.append('json', jsonLoader)
    JAVASCRIPT
  end

  gsub_file 'config/webpacker.yml', 'app/javascript', 'app/frontend'
  insert_into_file 'config/webpacker.yml', after: "- .mjs\n" do
    <<-YAML
    - .json
    YAML
  end
end

def setup_lib_pack
  run 'rm -r app/assets'
  file 'app/assets/config/manifest.js' do
    <<~JAVASCRIPT
    JAVASCRIPT
  end
  run 'mv app/javascript app/frontend'
  run 'mkdir app/frontend/images'

  # 共用library
  run 'mkdir app/frontend/libs'

  file 'app/frontend/stylesheets/custom.scss' do
    <<~CSS
    CSS
  end
  file 'app/frontend/stylesheets/libs.scss' do
    <<~CSS
      @import url("https://fonts.googleapis.com/css?family=Noto+Sans+TC:400,500,700,900&display=swap");
      * {
        font-family: "Noto Sans TC", sans-serif;
      }
      @import 'custom';
    CSS
  end

  file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT

    JAVASCRIPT
  end

  run 'rm -r app/frontend/packs/application.js'
  file 'app/frontend/packs/libs.js' do
    <<~JAVASCRIPT
      import "core-js/stable";
      import "regenerator-runtime/runtime";
      import Rails from "@rails/ujs"
      Rails.start()
      const images = require.context("../images", true)
      const imagePath = (name) => images(name, true)

      window.Rails = Rails
      import "../stylesheets/libs";
      import "../javascripts/libs";
    JAVASCRIPT
  end

  gsub_file 'app/views/layouts/application.html.erb', 'stylesheet_link_tag', 'stylesheet_packs_with_chunks_tag'
  gsub_file 'app/views/layouts/application.html.erb', 'javascript_pack_tag', 'javascript_packs_with_chunks_tag'
  gsub_file 'app/views/layouts/application.html.erb', 'application', 'libs'
end

def setup_plugins
  setup_i18njs
  setup_dayjs
  setup_localtime
  setup_fontawesome
  setup_bootstrap
  setup_flatpickr
  setup_pnotify
  setup_sweetalert
  setup_tippy
  # setup_uppy
end
