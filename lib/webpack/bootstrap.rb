# frozen_string_literal: true

def setup_bootstrap
  custom_bootstrap

  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/bootstrap";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/libs.scss' do
    <<~SCSS
      $enable-shadows: true;
      $enable-gradients: true;
      $enable-negative-margins: true;
      @import "~bootstrap/scss/bootstrap";
    SCSS
  end
end

def custom_bootstrap
  file 'app/frontend/libs/bootstrap.js' do
    <<~JAVASCRIPT
      import bootstrap from 'bootstrap'
    JAVASCRIPT
  end
end
