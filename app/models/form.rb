class Form < ActiveRecord::Base
  default_scope :order => 'forms.created_at DESC'
  include Permissions
  #acts_as_customizable 
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :project
  
  has_many :custom_fields
  accepts_nested_attributes_for :custom_fields, :allow_destroy => true
  
  has_many :responses            
  has_many :response_users, :through => :responses, :source => :creator
  
  has_many :notifies,  :as => :notifiable, :dependent => :destroy
  has_many :notify_users, :through => :notifies, :source => :user
  accepts_nested_attributes_for :notifies  
  
end
