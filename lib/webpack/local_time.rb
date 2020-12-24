# frozen_string_literal: true

def setup_localtime
  custom_localtime
  append_file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./localtime";
    JAVASCRIPT
  end
end

def custom_localtime
  file 'app/frontend/javascripts/localtime.js' do
    <<~JAVASCRIPT
      import LocalTime from "local-time"
      LocalTime.start()
    JAVASCRIPT
  end
end
