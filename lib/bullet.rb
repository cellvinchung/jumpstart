# frozen_string_literal: true

def setup_bullet
  bullet_gems

  after_bundle do
    content = <<~RUBY
      config.after_initialize do
        Bullet.enable = true
        Bullet.add_footer = true
        Bullet.console = true
      end
    RUBY

    environment "#{content}\n", env: 'development'

    inject_into_class 'app/jobs/application_job.rb', 'ApplicationJob' do
      <<~RUBY
        include Bullet::ActiveJob if Rails.env.development?
      RUBY
    end
  end
end

private

def bullet_gems
  gem 'bullet', '~> 6.1', '>= 6.1.5', group: %i[development]
end
