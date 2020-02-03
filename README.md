# Rails Jumpstart Template

Initialize rails project with custom configuration. See [Rails Application Templates](https://edgeguides.rubyonrails.org/rails_application_templates.html)

## Usage

1. git clone this project

2. rails new with template.rb

  ```shell
  rails new app_name -d postgresql --skip-turbolinks -m jumpstart/template.rb
  ```

## Content

### Development Experience

- [annotate](https://github.com/ctran/annotate_models) - Add a comment summarizing the current schema
- [bullet](https://github.com/flyerhzm/bullet) - Help to kill N+1 queries and unused eager loading
- [dotenv](https://github.com/bkeepers/dotenv) - Load environment variables from .env into ENV
- [letter_opener](https://github.com/ryanb/letter_opener) - Preview email in the default browser instead of sending it
- [pghero](https://github.com/ankane/pghero) - Performance dashboard for postgres
- [premailer-rails](https://github.com/fphilipe/premailer-rails) - CSS styled emails

### Assets Related

- webpacker
  - [bootstrap](https://getbootstrap.com/)
  - [data-confirm-modal](https://www.npmjs.com/package/data-confirm-modal)
  - [flatpicker](https://flatpickr.js.org/) - datepicker/datetimepicker
  - [font-awesome](https://fontawesome.com/icons?d=gallery&m=free)
  - [local time](https://www.npmjs.com/package/local-time)
  - [noty](https://ned.im/noty) - notification
  - [i18njs](https://www.npmjs.com/package/i18njs)
  - [axios](https://www.npmjs.com/package/axios) - Promise based HTTP client for the browser
- [gon](https://github.com/gazay/gon) - Use rails variables in js

### Presentation Related

- [draper](https://github.com/drapergem/draper) - Add object-oriented layer of presentation logic
- [friendly_id](https://github.com/norman/friendly_id) - Pretty URLs
- [babosa](https://github.com/norman/babosa) - Improvement of the string code from friendly_id
- [loaf](https://github.com/piotrmurach/loaf) - Breadcrumb
- [meta-tags](https://github.com/kpumuk/meta-tags) - Search Engine Optimization
- [pagy](https://github.com/ddnexus/pagy) - Pagination

### Security

- [lockbox](https://github.com/ankane/lockbox) - Encrypted fields and files
  - [blind_index](https://github.com/ankane/blind_index) - Securely search encrypted database fields
  - [kms_encrypted](https://github.com/ankane/kms_encrypted) - Secure key management

### Audits & Log

- [audited](https://github.com/collectiveidea/audited) - Logs all changes to models
- [lograge](https://github.com/roidrage/lograge) - Simplify rails' default request logging
- [marginalia](https://github.com/basecamp/marginalia) - Attach comments to ActiveRecord queries
- [notable](https://github.com/ankane/notable) - Tracks notable requests and background jobs and stores them in database

### Others

- disable auto generated stylesheets & helpers
- time zone: Taipei
- locale
  - default: zh-TW
  - available: zh-TW, en
  - split yml files into different folder
- add middleware `ActionDispatch::Static, Rack::Deflater` - [references](https://www.schneems.com/2017/11/08/80-smaller-rails-footprint-with-rack-deflate/)
- add hosts `lvh.me`
- i18n
  - [i18n-active_record](https://github.com/svenfuchs/i18n-active_record) - lookup translations in the database

### Optional

- devise
- pundit
- cloudflare-rails
- rollbar
