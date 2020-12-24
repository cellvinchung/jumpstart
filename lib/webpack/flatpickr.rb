# frozen_string_literal: true

def setup_flatpickr
  custom_flatpickr
  append_file 'app/frontend/javascripts/index.js' do
    <<~JAVASCRIPT
      import "./flatpickr";
    JAVASCRIPT
  end
  append_file 'app/frontend/stylesheets/application.scss' do
    <<~CSS
      @import "flatpickr/dist/flatpickr.min";
    CSS
  end
end

def custom_flatpickr
  file 'app/frontend/javascripts/flatpickr.js' do
    <<~JAVASCRIPT
      import flatpickr from 'flatpickr'
      import "flatpickr/dist/l10n/zh-tw"
      document.addEventListener('DOMContentLoaded', function(){
        flatpickr.localize(flatpickr.l10ns.zh_tw);
        flatpickr(".datepicker", {
        });
        flatpickr(".datetimepicker", {
          enableTime: true,
          time_24hr: true
        })
      })
    JAVASCRIPT
  end
end
