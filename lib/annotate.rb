# frozen_string_literal: true

def setup_annotate
  annotate_gems

  after_bundle do
    generate 'annotate:install'

    gsub_file 'lib/tasks/auto_annotate_models.rake',
              /'position_in_class'         => 'before'/,
              "'position_in_class'         => 'bottom'"

    run 'bundle exec annotate'
  end
end

private

def annotate_gems
  gem 'annotate', '~> 3.1', group: %i[development]
end
