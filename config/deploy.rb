set :keep_releases, 3
set :application, "supportr"

set :scm, :git
set :user, "mik"
set :repository,  "git@github.com:sudothinker/supportr.git"
set :branch, "master"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :port, 8888
set :deploy_to, "/home/mik/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :location, 's.sudothinker.com'
role :app, location
role :web, location
role :db,  location, :primary => true

set :deploy_via, :copy
set :copy_cache, true
set :runner, user

after "deploy:symlink", "supportr_symlink_configs"
after "deploy", "reload_nginx", "deploy:cleanup"

namespace :deploy do  
  desc "Restart the thins"  
  task :restart do  
    sudo "/etc/init.d/thin restart"  
  end  
end

desc "Reload Nginx"
task :reload_nginx do
  sudo "/etc/init.d/nginx reload"
end

# Symlink to non-standard environment-specific configuration
task :supportr_symlink_configs, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
  run <<-CMD
    ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
  CMD
  run <<-CMD
    ln -nfs #{shared_path}/config/mail.yml #{release_path}/config/mail.yml
  CMD
end