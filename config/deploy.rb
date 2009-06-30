# #==========================
# # ssh options
# #==========================
# default_run_options[:pty] = true
# # ssh_options[:paranoid] = false
# # ssh_options[:keys] = %w(~/.ssh/id_rsa)
# # ssh_options[:forward_agent] = true
# 
# #==========================
# # custom options
# #==========================
# set :user, "deploy"
# set :password, "deploy"
# set :use_sudo , false
# set :application, "heros"
# set :domain, "192.168.1.60"
# 
# 
# role :web, domain
# role :app, domain
# role :db, domain, :primary => true
# 
# #==========================
# # depoly to
# #==========================
# set :deploy_to, "/opt/webroot/#{application}-internal"
# 
# #==========================
# # repository
# #==========================
# set :repository,  "deploy@git:heros/mainline.git"
# set :scm, :git
# set :scm_verbose, true
# set :deploy_via, :remote_cache
# set :scm_user, "deploy"
# set :scm_passphrase, "deploy"
# set :branch, 'master'
# set :git_shallow_clone, 1
# 
# #==========================
# # database options
# #==========================
# set :rails_env, "internal"
# 
# #==========================
# # make the database.yml
# #==========================
# namespace :deploy do
#   desc "Create database yaml in shared path" 
#   task :after_setup do
#     database_configuration =<<-EOF
#     base: &base
#       adapter: mysql
#       username: root
#       password: bbg
#       encoding: utf8
#       host: 192.168.1.50
#     development:
#       database: #{application}_dev
#       <<: *base
#     test:
#       database: #{application}_test
#       <<: *base
#     production:
#       database: #{application}_production
#       <<: *base 
#     EOF
# 
#     run "mkdir -p #{shared_path}/config" 
#     put database_configuration, "#{shared_path}/config/database.yml" 
#     
#     cluster_configure = <<-EOF
#       --- 
#       cwd: /opt/webroot/heros-internal/current
#       log_file: log/mongrel.log
#       port: "3200"
#       environment: production
#       address: 127.0.0.1
#       pid_file: tmp/pids/mongrel.pid
#       servers: 2
#     EOF
#     put cluster_configure,"#{shared_path}/config/mongrel_cluster.yml"        
#     
#   end
# 
#   desc "Make symlink for shared config file" 
#   task :after_symlink, :roles => :app ,:except => {:no_symlink => true}do
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#     run "ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml"    
#     # run "ln -nfs /opt/webroot/statics/avatars #{release_path}/public/avatars"
#     # run "rm -rf #{release_path}/config/ultrasphinx/"
#     # run "ln -nfs #{shared_path}/config/ultrasphinx/default.base #{release_path}/config/ultrasphinx/default.base"
#     run "cd #{release_path} && RAILS_ENV=production rake db:migrate"
#     # run "cd #{release_path} && RAILS_ENV=internal rake ultrasphinx:configure"
#     # run "kill -9 $(cat /tmp/sphinx-searchd.pid)"
#     # run "indexer -c #{release_path}/config/ultrasphinx/internal.conf --all"
#     # run "searchd -c #{release_path}/config/ultrasphinx/internal.conf"   
#   end
#   
#   desc "restarting mongrel_cluster"
#   task :restart do
#     run "cd #{release_path} && RAILS_ENV=production mongrel_rails cluster::restart"
#   end
#   
# end
# 




####################################################################
set :application, "heros"  
set :user, "daveliu"  
set :runner, user  
set :use_sudo, true
set :repository,  "daveliu@58.30.227.14:/opt/git/heros"
set :deploy_to, "/home/daveliu/public_html/#{application}"
set :scm, :git
set :branch, "master"
set :location, "58.30.227.14"
role :app, location
role :web, location
role :db,  location , :primary => true   
set :deploy_via, :remote_cache
set :git_shallow_clone, 1         
default_run_options[:pty] = true
ssh_options[:paranoid] = false 
ssh_options[:keys] = %w(/Path/To/id_rsa)

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  desc "Restart the Passenger system."
  task :restart do    
  #  run "cd #{current_path}; rake db:migrate RAILS_ENV=production" 
    passenger.restart  
#    run "cd #{current_path}; script/daemons restart" 
  end
end     

after 'deploy:update_code', 'deploy:link_images' 
namespace(:deploy) do 
  task :link_images do
    run "rm -rf #{release_path}/public/attachments"
    run "mkdir -p #{shared_path}/system/attachments"
    run "ln -nfs #{shared_path}/system/attachments #{release_path}/public/attachments"                       
  end   
end





