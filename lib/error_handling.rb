# frozen_string_literal: true

def setup_error_handling
  after_bundle do
    generate 'controller errors'
    inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
      <<~RUBY
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

        def record_not_found
          render template: "errors/not_found", status: :not_found
        end
      RUBY
    end
  end
end
