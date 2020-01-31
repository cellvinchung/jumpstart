# frozen_string_literal: true

def setup_bootstrap
  custom_bootstrap

  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      import "bootstrap";
    JAVASCRIPT
  end

  append_file 'app/javascript/stylesheets/application.scss' do
    <<~CSS
      @import "bootstrap";
    CSS
  end
end

def custom_bootstrap
  add_file 'app/javascript/custom/bootstrap.js' do
    <<~JAVASCRIPT
      document.addEventListener("DOMContentLoaded", function() {
        $('[data-toggle="popover"]').popover();
        $('[data-toggle="tooltip"]').tooltip();
      });
    JAVASCRIPT
  end

  append_file 'app/javascript/packs/custom.js' do
    <<~JAVASCRIPT
      import '../custom/bootstrap';
    JAVASCRIPT
  end
end
