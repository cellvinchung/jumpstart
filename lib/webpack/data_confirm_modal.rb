# frozen_string_literal: true

def setup_data_confirm_modal
  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      import 'data-confirm-modal'
    JAVASCRIPT
  end
end
