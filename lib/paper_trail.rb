def setup_paper_trail
  generate 'paper_trail:install [--with-changes]'
  file 'app/model/version.rb' do
    <<~RUBY
      class Version < ::PaperTrail::Version
      end
    RUBY
  end

  initializer 'paper_trail.rb' do
    <<~RUBY
      PaperTrail.config.has_paper_trail_defaults = {
        skip: [:updated_at],
        versions: { class_name: 'Version' }
      }
    RUBY
  end
end
