class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
end
