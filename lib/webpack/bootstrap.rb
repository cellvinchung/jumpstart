# frozen_string_literal: true

def setup_bootstrap
  custom_bootstrap

  append_file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./bootstrap";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/application.scss' do
    <<~CSS
      @import "bootstrap";
    CSS
  end
end

def custom_bootstrap
  file 'app/frontend/javascripts/bootstrap.js' do
    <<~JAVASCRIPT
      import "bootstrap";
    JAVASCRIPT
  end
end
