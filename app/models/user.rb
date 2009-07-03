class User < ActiveRecord::Base
  acts_as_authentic     
  acts_as_authorization_subject
  
  
  has_many :messages, :class_name => "Message", :foreign_key => "creator_id"
  has_many :project_users, :dependent => :destroy
  has_many :projects,  :through => :project_users
  has_many :notifies
  
  has_attached_file :avatar,  
     :path => ":rails_root/public/attachments/avatars/:attachment/:id/:style/:basename.:extension",
     :url => "/attachments/avatars/:attachment/:id/:style/:basename.:extension",
     :styles => {
       :thumb=> "48x48#"
     },
     :default_url => "person_avatar.gif"
     
  def admin?
    has_role?("admin")
  end   
  
  def manager?
    has_role?("manager")
  end
end
