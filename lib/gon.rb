# frozen_string_literal: true

def setup_gon
  gon_gems

  after_bundle do
    insert_into_file 'app/views/layouts/application.html.erb', after: "<head>\n" do
      <<-ERB
      <%= Gon::Base.render_data %>
      ERB
    end
  end
end

private

def gon_gems
  gem 'gon'
end
