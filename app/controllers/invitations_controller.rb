class InvitationsController < ApplicationController   

  def new
    @invitation = Invitation.new  
  end    
  
  def create         
    if !params[:emails].blank?
      emails = params[:emails].split(",")
      invitations = []           
      emails.each do |email|
        invitations << Invitation.new(:recipient_email => email, :creator => current_user, :project_id => current_project.id)
      end
      Invitation.transaction { invitations.each &:save! } 
      flash[:notice] = "邮件发送成功"
      redirect_to :action => "new"   and return
    else                          
      @invitation = Invitation.new  
      flash[:error] = "请输入要邀请的邮箱"
      render :action => "new"
    end    
  rescue ActiveRecord::RecordInvalid => e
    @invitation = e.record                       
    if @invitation.errors.on(:recipient_email) == "已经有用户注册了"                  
      user = User.find_by_email(@invitation.recipient_email)
      flash[:notice] = "#{@invitation.recipient_email}这个邮箱的用户已经注册了俩个人，他的空间是<a target='_blank' href='#{couple_path(user.couple)}'>#{user.couple.name}</a>"  if user.couple
    end 
    render :action => "new"  
  end                        
  
  
  protected
  
   def allow_to
     super :user, :all => true
   end
end
