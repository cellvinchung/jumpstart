# frozen_string_literal: true

def setup_fontawesome
  custom_fontawesome
  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      import '@fortawesome/fontawesome-free/js/all'
    JAVASCRIPT
  end
  append_file 'app/javascript/stylesheets/application.scss' do
    <<~CSS
      @import "@fortawesome/fontawesome-free";
    CSS
  end
end

def custom_fontawesome
  add_file 'app/javascript/custom/fontawesome.js'

  append_file 'app/javascript/packs/custom.js' do
    <<~JAVASCRIPT
      import '../custom/fontawesome';
    JAVASCRIPT
  end
end
