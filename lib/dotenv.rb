# frozen_string_literal: true

def setup_dotenv
  dotenv_gems

  after_bundle do
    add_file '.env' do
      <<~CODE
        # detect `$rvm_path`
        if [ -z "${rvm_path:-}" ] && [ -x "${HOME:-}/.rvm/bin/rvm" ]
        then rvm_path="${HOME:-}/.rvm"
        fi
        if [ -z "${rvm_path:-}" ] && [ -x "/usr/local/rvm/bin/rvm" ]
        then rvm_path="/usr/local/rvm"
        fi

        # load environment of current project ruby
        if
          [ -n "${rvm_path:-}" ] &&
          [ -x "${rvm_path:-}/bin/rvm" ] &&
          rvm_project_environment=`"${rvm_path:-}/bin/rvm" . do rvm env --path 2>/dev/null` &&
          [ -n "${rvm_project_environment:-}" ] &&
          [ -s "${rvm_project_environment:-}" ]
        then
          echo "RVM loading: ${rvm_project_environment:-}"
          \. "${rvm_project_environment:-}"
        else
          echo "RVM project not found at: $PWD"
        fi
      CODE
    end
  end
end

private

def dotenv_gems
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.5', group: %i[development test]
end
