# frozen_string_literal: true

def setup_noty
  custom_noty

  append_file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./noty";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/application.scss' do
    <<~CSS
      @import "noty/src/noty";
      @import "noty/src/themes/bootstrap-v4.scss";
    CSS
  end
end

def custom_noty
  add_file 'app/frontend/javascripts/noty.js' do
    <<~JAVASCRIPT
      import Noty from 'noty';
      document.addEventListener("DOMContentLoaded", function() {
        Noty.overrideDefaults({
          theme: "bootstrap-v4",
          timeout: 3000,
          visibilityControl: true
        });

        if (gon.noty_message){
          gon.noty_message.forEach((noty) => {
            new Noty({
              type: noty.type,
              text: noty.text
            }).show();
          })
        }
      });
      window.Noty = Noty;
    JAVASCRIPT
  end
end
