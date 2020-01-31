# frozen_string_literal: true

def setup_noty
  custom_noty

  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      import Noty from 'noty';
      window.Noty = Noty;
    JAVASCRIPT
  end

  append_file 'app/javascript/stylesheets/application.scss' do
    <<~CSS
      @import "noty/src/noty";
      @import "noty/src/themes/bootstrap-v4.scss";
    CSS
  end
end

def custom_noty
  add_file 'app/javascript/custom/noty.js' do
    <<~JAVASCRIPT
    document.addEventListener("DOMContentLoaded", function() {
      Noty.overrideDefaults({
        theme: "bootstrap-v4",
        timeout: 3000,
        visibilityControl: true
      });
    });
    JAVASCRIPT
  end

  append_file 'app/javascript/packs/custom.js' do
    <<~JAVASCRIPT
      import '../custom/noty';
    JAVASCRIPT
  end
end
