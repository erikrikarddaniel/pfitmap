# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

# bundler bootstrap
require 'bundler/capistrano'
set :rvm_ruby_string, :local # use the same ruby as used locally for deployment #'ruby-2.0.0-p353' 
set :rvm_type, :system

before 'deploy:setup', 'rvm:install_rvm'  # install/update RVM
before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset, OR:
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset

# main details
set :application, "rnrdb"
role :web, "rnrdb.pfitmap.org"
role :app, "rnrdb.pfitmap.org"
role :db, "rnrdb.pfitmap.org", :primary => true

#server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/scratch/webapps/rnrdb.pfitmap.org"
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]
set :user, "passenger"
set :use_sudo, false
set :port, 50021

#repo details
set :scm, :git
set :repository, "git@github.com:erikrikarddaniel/pfitmap.git"
set :branch, "stable"
set :git_enable_submodules, 1

## Cronjobs for rails
#namespace :scheduler_daemon do
#  task :start, :roles => :app do
#    run "cd #{release_path} && RAILS_ENV=production bundle exec scheduler_daemon start"
#  end
#  task :stop, :roles => :app do
#    run "cd #{release_path} && RAILS_ENV=production bundle exec scheduler_daemon stop"
#  end
#  task :restart, :roles => :app do
#    run "cd #{release_path} && RAILS_ENV=production bundle exec scheduler_daemon restart"
#  end
#end

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
#THIS links the database file which is stored locally on the application server to the current release.
namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "ln -s ~/webappdbs/rnrdb.pfitmap.org/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "db:db_config"

#This is neccessary, this will precompile assets. If this is missing we will get strange problems with no errors in the logs.
load 'deploy/assets'

# Delayed job daemon
require "delayed/recipes"

set :rails_env, "production" #added for delayed job

after "deploy:stop",    "delayed_job:stop"#,	"scheduler_daemon:stop"
after "deploy:start",   "delayed_job:start"#,	"scheduler_daemon:start"
after "deploy:restart", "delayed_job:restart"#,	"scheduler_daemon:restart"



