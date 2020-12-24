# frozen_string_literal: true

def setup_fontawesome
  custom_fontawesome
  append_file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./fontawesome";
    JAVASCRIPT
  end
  append_file 'app/frontend/stylesheets/application.scss' do
    <<~CSS
      @import "@fortawesome/fontawesome-free";
    CSS
  end
end

def custom_fontawesome
  file 'app/frontend/javascripts/fontawesome.js' do
    import '@fortawesome/fontawesome-free/js/all'
  end
end
