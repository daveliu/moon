# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user, 
                :render_to_string, :controller_name, :action_name, :current_project  
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :require_user, :set_body_class, :set_current_project
  
  
  private                                                               
    #-----------maybe better way????
    def set_current_project
      session[:project_id] ||= params[:project_id] if params[:project_id]
    end
  
    def current_project            
      return @current_project if defined?(@current_project)
      @current_project = Project.find_by_id(session[:project_id])  #||  Project.first
    end                                                                            
    
    def set_body_class
      @body_class = ""
    end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
#        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
#        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end    
    
    def to_model(type)  #like post
      ActiveSupport::Inflector.constantize(ActiveSupport::Inflector.camelize(type)) 
    end

    def to_controller(type)
      ActiveSupport::Inflector.underscore(type).pluralize 
    end
  
end
