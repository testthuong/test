require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '10.0.0.13'
set :deploy_to, '/home/tech/cc'
#set :source, '~/SearchThuong'
set :term_mode, nil
 set :repository, 'git@github.com:testthuong/test.git'#'https://gitlab.chudu24.com/thuong.minh/test.git'
 set :branch, 'master'
set :foreman_sudo, false
#set :identity_file, '/root/.ssh/gitlab_public_key'
# set :pid_file, "#{deploy_to}/shared/tmp/pids/#{rails_env}.pid"
# set :app_path, lambda { "#{deploy_to}/#{current_path}" }
# For system-wide RVM install.
# set :rvm_path, '/usr/local/rvm/bin/rvm'

# set_default :rbenv_ruby_version, "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.

set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']

# Optional settings:
  set :pid_file, "#{deploy_to}/shared/tmp/pids/#{rails_env}.pid"

  set :user, 'tech'    # Username in the server to SSH to.
  set :pass, '123456'
  set :port, '22'     # SSH port number.
  set :forward_agent, true     # SSH forward_agent.
#set :bundle_bin, %{PATH="#{deploy_to}/bin:$PATH" GEM_HOME="#{deploy_to}/gems" RUBYLIB="#{deploy_to}/lib" RAILS_ENV=#{env} #{deploy_to}/bin/bundle}



# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  #invoke :'rbenv:load'

  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  #  invoke :'rvm:use[ruby-1.9.3-p125@default]'

  # ruby_version = File.read('.ruby-version').strip
  # raise "Couldn't determine Ruby version: Do you have a file .ruby-version in your project root?" if ruby_version.empty?
  # queue %{
  #   source path/to/rvm
  #   rvm use #{ruby_version} || exit 1
  # }



end



# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do






  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]

  #
  #
  #
  #
  #
  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end

  # queue %[
  #   repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
  #   repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
  #   if [ -z "${repo_port}" ]; then repo_port=22; fi &&
  #   ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  # ]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  queue "export ..."
  deploy do
    # to :prepare do
    #   # invoke :stop unless ENV['SKIP_STOP']
    # end
    # invoke :'rails:assets_precompile:force'
    # queue %[echo "-----> Copy source"]
    # queue "cp -r #{source}/config.ru"


    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      # invoke :start unless ENV['SKIP_START']
      # queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end


# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
