def setup_tippy
  custom_tippy
  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/tippy";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/libs.scss' do
    <<~CSS
      @import 'tippy.js/dist/tippy';
      @import 'tippy.js/themes/light.css';
    CSS
  end
end

def custom_tippy
  file 'app/frontend/libs/tippy.js' do
    <<~JAVASCRIPT
      import tippy from 'tippy.js';
      document.addEventListener("DOMContentLoaded", () => {
        tippy('[data-toggle="tooltip"]', {
          content(reference) {
            const title = reference.getAttribute('title');
            reference.removeAttribute('title');
            return title;
          },
        });
      });
    JAVASCRIPT
  end
end
