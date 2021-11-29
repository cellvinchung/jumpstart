# frozen_string_literal: true

def setup_localtime
  custom_localtime
  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/localtime";
    JAVASCRIPT
  end
end

def custom_localtime
  file 'app/frontend/libs/localtime.js' do
    <<~JAVASCRIPT
      import LocalTime from "local-time"
      LocalTime.start()
    JAVASCRIPT
  end
end
