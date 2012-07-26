# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
# bundler bootstrap
require 'bundler/capistrano'
set :rvm_ruby_string, '1.9.3-p194'
set :rvm_type, :system

# main details
set :application, "rnrdb"
role :web, "rnrdb.pfitmap.org"
role :app, "rnrdb.pfitmap.org"
role :db, "rnrdb.pfitmap.org", :primary => true

#server details
default_run_options[:pty] = true
#ssh_options[:forward_agent] = true
set :deploy_to, "/scratch/webapps/rnrdb.pfitmap.org"
set :deploy_via, :remote_cache
set :user, "passenger"
set :use_sudo, false
set :port, 50021

#repo details
set :scm, :git
set :repository, "git@github.com:alneberg/pfitmap.git"
set :branch, "stable"
set :git_enable_submodules, 1

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
