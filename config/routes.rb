ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users, :collection => {:admin => :any}
  map.resource :user_session
  map.connect 'logout', :controller => "user_sessions", :action => "destroy"
  map.connect 'time_entries/report', :controller => "time_entries", :action => "report" 

  map.resources :projects, :has_many => [:messages, :assets, :time_entries, :todo_lists, :categories, :forms], 
   :collection => {:project_users => :get, :search => :get}, 
   :member => {:add_user => :any, :create_project_user => :post, :update_project_user => :post},
   :shallow => true 
   
  map.resources :roles 
   
#  map.resources :todo_lists, :path_prefix => '/projects/:project_id', :has_many => :todos, :shallow => true                                
  map.resources :todos, :path_prefix => "/todo_lists/:todo_list_id", :has_many => :time_entries, :shallow => true, :member => {:add_time_entry => :post}
  map.resources :responses, :path_prefix => "/forms/:form_id", :shallow => true
  map.complete_todo 'todos/:id/complete', :controller => "todos", :action => "complete"
  map.reopen_todo 'todos/:id/reopen', :controller => "todos", :action => "reopen"
  
  map.complete_todo_list 'todo_lists/:id/complete', :controller => "todo_lists", :action => "complete"
  map.reopen_todo_list 'todo_lists/:id/reopen', :controller => "todo_lists", :action => "reopen"
  map.resources :milestones, :path_prefix => '/projects/:project_id', :shallow => true, :member => {:complete => :post, :reopen => :post}                                                                
  
  map.resources :invitations
#  map.resources :assets      
#  map.connect 'todos/:id/time_entries', :controller => "time_entries"
#  map.resources :time_entries
  map.resources :comments, :path_prefix => '/:commentable_type/:commentable_id', :shallow => true
  
  map.home 'home', :controller => "projects", :action => "index"
  map.root  :controller => "projects", :action => "index"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
