class TimelineEvent < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
end
