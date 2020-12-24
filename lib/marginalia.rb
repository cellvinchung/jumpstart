def setup_marginalia
  marginalia_gems

  after_bundle do
    initializer 'marginalia.rb' do
      <<~RUBY
        Marginalia::Comment.prepend_comment = true
        Marginalia::Comment.components = [:application, :controller, :action, :job, :pid]
      RUBY
    end
  end
end

private

def marginalia_gems
  gem 'marginalia', '~> 1.9'
end
