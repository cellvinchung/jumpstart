def setup_dayjs
  custom_dayjs

  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/day";
    JAVASCRIPT
  end
end

def custom_dayjs
  file 'app/frontend/libs/day.js' do
    <<~JAVASCRIPT
      import dayjs from "dayjs";
      import AdvancedFormat from "dayjs/plugin/advancedFormat";
      import CustomParseFormat from "dayjs/plugin/customParseFormat";
      import calender from "dayjs/plugin/calendar";
      require("dayjs/locale/zh-tw");
      require("dayjs/locale/en");
      const locale = lodash.lowerCase(gon.locale);
      dayjs.locale(locale);
      dayjs.extend(AdvancedFormat);
      dayjs.extend(CustomParseFormat);
      dayjs.extend(calender);
      window.dayjs = dayjs;

    JAVASCRIPT
  end
end