class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :data,  
     :path => ":rails_root/public/assets/:attachment/:id/:style/:basename.:extension",
     :url => "/assets/:attachment/:id/:style/:basename.:extension",
     :styles => {
       :thumb=> "100x100#",
       :small  => "200x200>" }
end
