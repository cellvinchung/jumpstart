# frozen_string_literal: true

def setup_fontawesome
  custom_fontawesome
  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/fontawesome";
    JAVASCRIPT
  end
  append_file 'app/frontend/stylesheets/libs.scss' do
    <<~CSS
      @import "@fortawesome/fontawesome-free";
    CSS
  end
end

def custom_fontawesome
  file 'app/frontend/libs/fontawesome.js' do
    <<~JAVASCRIPT
      import { library, dom } from "@fortawesome/fontawesome-svg-core";
      import { fas } from "@fortawesome/free-solid-svg-icons";
      import { far } from "@fortawesome/free-regular-svg-icons";
      import { fab } from "@fortawesome/free-brands-svg-icons";
      library.add(fas, far, fab);
      dom.watch();
    JAVASCRIPT
  end
end
