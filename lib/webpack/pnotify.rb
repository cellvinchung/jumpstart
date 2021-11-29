# frozen_string_literal: true

def setup_pnotify
  custom_pnotify

  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/pnotify";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/libs.scss' do
    <<~CSS
      @import '@pnotify/core/dist/PNotify';
      @import '@pnotify/countdown/dist/PNotifyCountdown';
      @import '@pnotify/mobile/dist/PNotifyMobile';
      @import '@pnotify/core/dist/BrightTheme';
    CSS
  end
end

def custom_pnotify
  file 'app/frontend/libs/pnotify.js' do
    <<~JAVASCRIPT
      import { alert, defaultModules } from '@pnotify/core';
      import * as PNotifyCountdown from '@pnotify/countdown';
      import * as PNotifyDesktop from '@pnotify/desktop';
      import * as PNotifyMobile from '@pnotify/mobile/dist/PNotifyMobile';
      import * as PNotifyFontAwesome5Fix from '@pnotify/font-awesome5-fix';
      import * as PNotifyFontAwesome5 from '@pnotify/font-awesome5';
      defaultModules.set(PNotifyDesktop, {});
      defaultModules.set(PNotifyMobile, {
        swipeDismiss: true
      });
      defaultModules.set(PNotifyFontAwesome5Fix, {});
      defaultModules.set(PNotifyFontAwesome5, {});

      window.Notify = (type, message, title) => {
        alert({
          text: message,
          type: type,
          title: title,
          delay: 5000,
          modules: new Map([
            ...defaultModules,
            [PNotifyCountdown, {
              // Countdown Module Options
            }]
          ])
        })
      };

      document.addEventListener("DOMContentLoaded", () => {
        if(gon.notify){
          gon.notify.forEach((notify) => {
            Notify(notify.type, notify.message, notify.title);
          })
        }
      })
    JAVASCRIPT
  end
end
