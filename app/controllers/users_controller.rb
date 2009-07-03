class UsersController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
  resource_controller
  
  
  def index             
    @accounts = User.all
  end                           
  
  def new
    @user = User.new
    @body_class = ""
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = User.find(params[:id])
    @body_class = "edit_person companies unprintable"
  end
  
  def update
    @user = User.find(params[:id]) # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to edit_user_path(@user)
    else
      render :action => :edit
    end
  end                             
  
  def admin          
    @body_class = "candidates administrators new_candidates has_flash_support"
    @users = User.all
    
    if request.post?
      @users.each do |user|
        user.has_no_role!("admin")
      end
      params[:admins].each do |id|          
        User.find_by_id(id).has_role!(:admin)
      end    
      flash.now[:notice] = "save success"        
    end    

  end
  
  
  
  private
  def set_body_class
    @body_class = "companies"
  end
end
