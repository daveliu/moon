class User < ActiveRecord::Base
  acts_as_authentic     
  
  has_many :messages, :class_name => "Message", :foreign_key => "creator_id"
  
  has_attached_file :avatar,  
     :path => ":rails_root/public/avatars/:attachment/:id/:style/:basename.:extension",
     :url => "/avatars/:attachment/:id/:style/:basename.:extension",
     :styles => {
       :thumb=> "48x48#"
     }
end
