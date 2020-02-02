# frozen_string_literal: true

def setup_annotate
  p 'setup annotate started'
  annotate_gems

  after_bundle do
    generate 'annotate:install'

    gsub_file 'lib/tasks/auto_annotate_models.rake',
              /'position_in_class'         => 'before'/,
              "'position_in_class'         => 'bottom'"

    run 'bundle exec annotate'
  end
  p 'setup annotate finished'
end

private

def annotate_gems
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git', group: %i[development]
end
