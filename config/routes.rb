ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  map.connect 'logout', :controller => "user_sessions", :action => "destroy"

  map.resources :projects, :has_many => [:messages, :assets, :time_entries, :todo_lists, :categories, :forms], 
   :collection => {:project_users => :get}, 
   :member => {:add_user => :any, :update_project_user => :post},
   :shallow => true 
#  map.resources :todo_lists, :path_prefix => '/projects/:project_id', :has_many => :todos, :shallow => true                                
  map.resources :todos, :path_prefix => "/todo_lists/:todo_list_id", :has_many => :time_entries, :shallow => true, :member => {:add_time_entry => :post}
  map.resources :responses, :path_prefix => "/forms/:form_id", :shallow => true
  map.complete_todo 'todos/:id/complete', :controller => "todos", :action => "complete"
  map.reopen_todo 'todos/:id/reopen', :controller => "todos", :action => "reopen"
  map.resources :milestones, :path_prefix => '/projects/:project_id', :shallow => true, :member => {:complete => :post, :reopen => :post}                                                                
  
  map.resources :invitations
#  map.resources :assets      
#  map.connect 'todos/:id/time_entries', :controller => "time_entries"
#  map.resources :time_entries
  map.resources :comments, :path_prefix => '/:commentable_type/:commentable_id', :shallow => true
  
  map.home 'home', :controller => "home"
  map.root :controller => "home"     
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
