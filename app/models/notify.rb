class Notify < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  belongs_to :user
  
  before_save :remove_blank_user
  after_save :send_email
  
  private 
  def remove_blank_user     #-------maybe be better?
    if user_id.nil? || user_id == 0
      if !self.new_record?
        self.destroy 
      end  
      return false
   end  
  end                   
  
  def send_email
   # Mailer.send_later(:deliver_notify, self)
    Mailer.deliver_notify(self)
  end
end
