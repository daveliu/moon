# == Schema Information
# Schema version: 20090123052734
#
# Table name: invitations
#
#  id                   :integer(4)    not null, primary key
#  sender_id            :integer(4)    
#  recipient_email      :string(255)   
#  recipient_email_body :string(255)   
#  token                :string(255)   
#  created_at           :datetime      
#  updated_at           :datetime      
#

class Invitation < ActiveRecord::Base       
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :project
  
  validates_presence_of :recipient_email    
  validates_format_of :recipient_email,
	                    :with => /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/
  validate :recipient_is_not_registered
  
  before_create :generate_token
  after_save :send_mail
  private
  
  def recipient_is_not_registered
    errors.add :recipient_email, "已经有用户注册了" if User.find_by_email(recipient_email)
  end                          
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end                  
  
  def send_mail
    Mailer.deliver_invitation(self)     
#    Mailer.send_later(:deliver_invitation, self)  #delayed_job
  end
end
