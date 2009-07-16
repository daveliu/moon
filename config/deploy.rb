#内网系统应用的名称和部署域
set :application, "intranet"
set :domain, "www.pro.beibeigan.com"
#==========================
# ssh options
#==========================
default_run_options[:pty] = true
# ssh_options[:paranoid] = false
# ssh_options[:keys] = %w(~/.ssh/id_rsa)
# ssh_options[:forward_agent] = true

#==========================
# custom options
#==========================
set :user, "deploy"
set :password, "deploy.linode"
set :use_sudo , false

role :web, domain
role :app, domain
role :db, domain, :primary => true

#==========================
# depoly to
#==========================
set :deploy_to, "/opt/webroot/#{application}"

#==========================
# repository
#==========================
set :repository,  "git://github.com/daveliu/moon.git"
set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache
# set :scm_user, "deploy"
# set :scm_passphrase, "deploy"
set :branch, 'master'
set :git_shallow_clone, 1

set :rails_env, "production"

namespace :deploy do
 desc "Create database yaml in shared path" 
 task :after_setup do
   # do something at here. like generate shared files
 end

 desc "Make symlink for shared config file" 
 task :after_symlink, :roles => :app ,:except => {:no_symlink => true}do
   run "rm -rf #{release_path}/public/attachments"
   run "mkdir -p #{shared_path}/system/attachments"
   run "ln -nfs #{shared_path}/system/attachments #{release_path}/public/attachments"
 end

 desc "restarting mongrel_cluster"
 task :restart do
   run "cd #{release_path} && touch tmp/restart.txt"
 end

end