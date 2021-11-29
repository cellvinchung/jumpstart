# My Rails Application Template

Initialize rails project with custom configuration. See [Rails Application Templates](https://edgeguides.rubyonrails.org/rails_application_templates.html)

## Usage

1. git clone this project

2. rails new with template.rb

  ```shell
  rails new app_name -d postgresql --skip-turbolinks -m jumpstart/template.rb
  ```

3. add/move keys to credentials or .env file

4. reorder gems in Gemfile for [better practice](https://docs.rubocop.org/rubocop/1.23/cops_bundler.html#bundlerorderedgems)

## Content(WIP)

### Application Settings

- Disable auto generated stylesheets & helpers
- Time zone: Taipei
- Add middleware `ActionDispatch::Static, Rack::Deflater` - [smaller rails page size](https://www.schneems.com/2017/11/08/80-smaller-rails-footprint-with-rack-deflate/)
- Add hosts `lvh.me` & `.ngrok.io`
- require master_key
- I18n
  - [i18n-active_record](https://github.com/svenfuchs/i18n-active_record) - Lookup translations in the database
- Enable [webpack chunks](https://github.com/rails/webpacker/blob/master/docs/webpack.md#add-splitchunks-webpack-v4)
- Locale
  - default: zh-TW
  - available: zh-TW, en
  - load path: `config/locales/**/*.{yml,rb}`

### Development Experience

- [annotate](https://github.com/ctran/annotate_models) - Add a comment summarizing the current schema
- [bullet](https://github.com/flyerhzm/bullet) - Help to kill N+1 queries and unused eager loading
- [dotenv](https://github.com/bkeepers/dotenv) - Load environment variables from .env into ENV
- [letter_opener](https://github.com/ryanb/letter_opener) - Preview email in the default browser instead of sending it
- [premailer-rails](https://github.com/fphilipe/premailer-rails) - CSS styled emails
- [pry-rails](https://github.com/rweng/pry-rails) - Better IRB shell
- [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler) - Displays speed badge for every html page
  - [memory_profiler](https://github.com/SamSaffron/memory_profiler) - For memory profiling
  - [flamegraph](https://github.com/SamSaffron/flamegraph) & [stackprof](https://github.com/tmm1/stackprof) - For call-stack profiling flamegraphs
- [better_errors](https://github.com/BetterErrors/better_errors) - Better error page
- [cacheflow](https://github.com/ankane/cacheflow) - Colorized logging for Memcached and Redis
- [capistrano](https://github.com/capistrano/capistrano) - Deployment automation
  - [capistrano-passenger](https://github.com/capistrano/passenger)
- [rails-erd](https://github.com/voormedia/rails-erd) - Generate entity-relationship diagrams
- Add `Procfile` for [foreman](https://github.com/ddollar/foreman). ([DON'T install foreman in projects!](https://github.com/ddollar/foreman/wiki/Don't-Bundle-Foreman))

### Assets Related

- [webpacker](https://github.com/rails/webpacker)
  - [bootstrap](https://getbootstrap.com/)
  - [flatpicker](https://flatpickr.js.org/) - datepicker/datetimepicker
  - [font-awesome](https://fontawesome.com/icons?d=gallery&m=free)
  - [pnotify](https://github.com/sciactive/pnotify) - notification
  - [i18njs](https://www.npmjs.com/package/i18njs)
  - [axios](https://www.npmjs.com/package/axios) - Promise based HTTP client for the browser
  - [day.js](https://day.js.org/)
  - [lodash](https://lodash.com/)
  - [sweetalert2](https://sweetalert2.github.io/) - Override Rails data-confirm dialog
  - [tippy](http://atomiks.github.io/tippyjs/) - Tooltip
- [gon](https://github.com/gazay/gon) - Use rails variables in js
- [inline_svg](https://github.com/jamesmartin/inline_svg) - Styling SVG documents with CSS

### Presentation Related

- [active_link_to](https://github.com/comfy/active_link_to) - View helper to manage `active` state of a link
- [draper](https://github.com/drapergem/draper) - Add object-oriented layer of presentation logic
- [friendly_id](https://github.com/norman/friendly_id) - Pretty URLs
  - [babosa](https://github.com/norman/babosa) - Improvement of the string code from friendly_id
- [loaf](https://github.com/piotrmurach/loaf) - Breadcrumb
- [pagy](https://github.com/ddnexus/pagy) - Pagination
- [simple_form](https://github.com/heartcombo/simple_form) - Forms made easy for rails (initialized with bootstrap)
- [sitemap_generator](https://github.com/kjvarga/sitemap_generator)
- [meta-tags](https://github.com/kpumuk/meta-tags)
- [local time](https://github.com/basecamp/local_time) - Display times and dates to users in their local time

### Background Job

- [sidekiq](https://github.com/mperham/sidekiq)
  - [activejob-traffic_control](https://github.com/nickelser/activejob-traffic_control) - Rate limiting/job enabling for ActiveJob using distributed locks
  - [sidekiq-statistic](https://github.com/davydovanton/sidekiq-statistic) - Improved display of statistics
  - [sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler) - Scheduler for Sidekiq jobs
  - [sidekiq-status](https://github.com/utgarda/sidekiq-status) - An extension to Sidekiq message processing to track jobs
  - [sidekiq-failures](https://github.com/mhfs/sidekiq-failures) - Keeps track of Sidekiq failed jobs and adds a tab to the Web UI to let you browse them

### Security

- [lockbox](https://github.com/ankane/lockbox) - Encrypted fields and files
  - [blind_index](https://github.com/ankane/blind_index) - Securely search encrypted database fields
  - [kms_encrypted](https://github.com/ankane/kms_encrypted) - Secure key management
- [brakeman](https://github.com/presidentbeef/brakeman) - Checks rails applications for security vulnerabilities
- [rack-attack](https://github.com/kickstarter/rack-attack) - Rack middleware for blocking & throttling

### Performance

- [oj](https://github.com/ohler55/oj) - Speed up JSON parsing
- [counter_culture](https://github.com/magnusvk/counter_culture) - Huge improvements over the rails standard counter caches
- [activerecord_where_assoc](https://github.com/MaxLap/activerecord_where_assoc) - do conditions based on the associations (Using SQL's `EXISTS` operator)

### Tracking & Log Related

- [paper_trail](https://github.com/paper-trail-gem/paper_trail) - Track changes to models
- [lograge](https://github.com/roidrage/lograge) - Simplify rails' default request logging
- [marginalia](https://github.com/basecamp/marginalia) - Attach comments to ActiveRecord queries

### Test

- [rspec-rails](https://github.com/rspec/rspec-rails)

### Others

- [slowpoke](https://github.com/ankane/slowpoke) - Rack::Timeout enhancements for rails
- [whenever](https://github.com/javan/whenever) - Cron jobs in Ruby
- [discard](https://github.com/jhawthorn/discard) - Soft delete
- [strip_attributes](https://github.com/rmm5t/strip_attributes) - Automatically strips leading and trailing whitespace
- [browser](https://github.com/fnando/browser) - Browser detection
- [aasm](https://github.com/aasm/aasm) - State machine
  - [after_commit_everywhere](https://github.com/Envek/after_commit_everywhere) - Prevent race conditions and redundant callback calls within nested transaction
- [http](https://github.com/httprb/http) - Ruby HTTP client
- [activerecord-import](https://github.com/zdennis/activerecord-import) - Bulk inserting data using ActiveRecord
- [groupdate](https://github.com/ankane/groupdate) - Group time data
- [deep_cloneable](https://github.com/moiristo/deep_cloneable) - Clone including associations
- [flipper](https://github.com/jnunemaker/flipper) - Feature flags

### Optional

- [devise](https://github.com/heartcombo/devise) - Authentication
  - [pundit](https://github.com/varvet/pundit) - Authorization
  - [omniauth-google-oauth2](https://github.com/zquestz/omniauth-google-oauth2)
  - [omniauth-facebook](https://github.com/simi/omniauth-facebook)
  - [omniauth-twitter](https://github.com/arunagw/omniauth-twitter)
