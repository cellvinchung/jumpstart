# frozen_string_literal: true

def setup_flatpickr
  custom_flatpickr
  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/flatpickr";
    JAVASCRIPT
  end
  append_file 'app/frontend/stylesheets/libs.scss' do
    <<~CSS
      @import "flatpickr/dist/flatpickr.min";
      @import "flatpickr/dist/plugins/monthSelect/style";
    CSS
  end
end

def custom_flatpickr
  file 'app/frontend/libs/flatpickr.js' do
    <<~JAVASCRIPT
      import flatpickr from 'flatpickr'
      import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect/index.js";
      import "flatpickr/dist/l10n/zh-tw"
      document.addEventListener('DOMContentLoaded', () => {
        if (gon.locale == 'zh-TW'){
          flatpickr.localize(flatpickr.l10ns.zh_tw);
        }
        flatpickr(".datepicker", {
        });
        flatpickr(".datetimepicker", {
          enableTime: true,
          time_24hr: true
        });
        flatpickr(".monthpicker", {
          plugins: [
            new monthSelectPlugin({
              shorthand: true,
              dateFormat: "Y-m",
              altInput: true,
            }),
          ],
        });
      })
    JAVASCRIPT
  end
end
