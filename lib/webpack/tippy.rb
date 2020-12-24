def setup_tippy
  custom_tippy
  append_file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./tippy";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/application.scss' do
    <<~CSS
      @import 'tippy.js/dist/tippy.css';
    CSS
  end
end

def custom_tippy
  file 'app/frontend/javascripts/tippy.js' do
    <<~JAVASCRIPT
      import tippy from 'tippy.js';
      document.addEventListener("DOMContentLoaded", function() {
        tippy('[data-toggle="tooltip"]');
      });
    JAVASCRIPT
  end
end
