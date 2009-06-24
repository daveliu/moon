class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :data,  
     :path => ":rails_root/public/assets/:attachment/:id/:style/:basename.:extension",
     :url => "/assets/:attachment/:id/:style/:basename.:extension",
     :styles => {
       :thumb=> "100x100#",
       :small  => "200x200>" }
       
  before_data_post_process :prevent_thumbnail   
  
  Content_Types  = ['image/jpeg', 'image/pjpeg', 'image/gif', 
        'image/png', 'image/x-png', 'image/jpg']
        
  named_scope :images, :conditions => ["data_content_type  IN (?)", Content_Types]      
  named_scope :not_images, :conditions => ["data_content_type  NOT IN (?)", Content_Types]      
  
  private      
  def prevent_thumbnail                           
    return false if !Content_Types.include?(data_content_type) 
  end     
end
