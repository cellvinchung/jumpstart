# frozen_string_literal: true

def setup_localtime
  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      require("local-time").start()
    JAVASCRIPT
  end
end
