# frozen_string_literal: true

def setup_gon
  gon_gems

  after_bundle do
    insert_into_file 'app/views/layouts/application.html.erb', after: "<head>\n" do
      <<-ERB
      <%= Gon::Base.render_data %>
      ERB
    end

    inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
      <<~RUBY
        before_action :set_locale
        before_action :prepare_notify

        def set_locale
          gon.locale = I18n.locale
          gon.default_locale = I18n.default_locale
        end

        def prepare_notify
          gon.notify = []
          flash.each do |type, message|
            message = t('devise.failure.timeout') if type.to_s == 'timedout'
            type = 'warning' if %w[alert timedout].include?(type.to_s)
            type = 'info' if %w[notice].include?(type.to_s)

            gon.notify << { type: type, message: message }
          end
        end
      RUBY
    end
  end
end

private

def gon_gems
  gem 'gon', '~> 6.4'
end
