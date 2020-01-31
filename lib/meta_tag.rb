# frozen_string_literal: true

def setup_meta_tag
  meta_tag_gems
  after_bundle do
    generate 'meta_tags:install'

    custom_layout
    custom_controller
  end
end

private

def meta_tag_gems
  gem 'meta-tags'
end

def custom_layout
  insert_into_file 'app/views/layouts/application.html.erb', after: "<head>\n" do
    <<-ERB
      <%= display_meta_tags %>
    ERB
  end
end

def custom_controller
  inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
    <<-RUBY
      before_action :prepare_meta_tags

      def prepare_meta_tags(opts = {})
        set_meta_tags(
          viewport: 'width=device-width, initial-scale=1, shrink-to-fit=no',
          charset: 'utf-8',
          'apple-mobile-web-app-capable': 'yes',
          'apple-touch-fullscreen': 'yes'
        )
      end
    RUBY
  end
end
