class Comment < ActiveRecord::Base                                        
    include Permissions
  
  has_many :assets, :as => :attachable,    :dependent => :destroy, :order => 'created_at ASC'
  
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  
  accepts_nested_attributes_for :assets                                                      
  
  
end
