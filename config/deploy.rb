require "bundler/capistrano"
require "capistrano-resque"

set :application, "fcrepo4-demo-hydra-app"
set :repository,  "git://github.com/futures/fcrepo4-demo-hydra-app.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "hydra.fcrepo.org"                          # Your HTTP server, Apache/etc
role :app, "hydra.fcrepo.org"                          # This may be the same as your `Web` server
role :db,  "hydra.fcrepo.org", :primary => true # This is where Rails migrations will run
role :resque_worker, "hydra.fcrepo.org"
role :resque_scheduler, "hydra.fcrepo.org"

set :workers, { '*' => 1 }

set :use_sudo, false
set :ssh_options, { :forward_agent => true }

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :branch, "master"

set :deploy_to, "/opt/fcrepo4-demo-hydra-app"
set :shared_children, %w( db log config/database.yml config/fedora.yml config/solr.yml config/redis.yml config/initializers/secret_token.rb tmp/pids  )
# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code", "deploy:migrate"
after "deploy:restart", "resque:restart"