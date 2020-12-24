def setup_rollout
  rollout_gems
  after_bundle do
    initializer 'rollout.rb' do
      <<~RUBY
        redis = Redis.new(url: "#{ENV.fetch('REDIS_URL')}/1")
        $rollout = Rollout.new(redis)
      RUBY
    end
  end
end

def rollout_gems
  gem_group :production, :development do
    gem 'rollout', '~> 2.5'
  end
end
