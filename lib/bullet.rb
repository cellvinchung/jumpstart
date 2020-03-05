# frozen_string_literal: true

def setup_bullet
  bullet_gems

  after_bundle do
    content = <<~RUBY
      config.after_initialize do
        Bullet.enable = true
        Bullet.add_footer = true
      end
    RUBY

    environment "#{content}\n", env: 'development'
  end
end

private

def bullet_gems
  gem 'bullet', '~> 6.1', group: %i[development]
end
