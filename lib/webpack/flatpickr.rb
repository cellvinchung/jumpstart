# frozen_string_literal: true

def setup_flatpickr
  custom_flatpickr
  append_file 'app/javascript/packs/application.js' do
    <<~JAVASCRIPT
      import flatpickr from 'flatpickr'
      import "flatpickr/dist/l10n/zh-tw"
    JAVASCRIPT
  end
  append_file 'app/javascript/stylesheets/application.scss' do
    <<~CSS
      @import "flatpickr/dist/flatpickr.min";
    CSS
  end
end

def custom_flatpickr
  add_file 'app/javascript/custom/flatpickr.js' do
    <<~JAVASCRIPT
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
  append_file 'app/javascript/packs/custom.js' do
    <<~JAVASCRIPT
      import '../custom/flatpickr';
    JAVASCRIPT
  end
end
