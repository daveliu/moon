class Response < ActiveRecord::Base     
  include Permissions
  #acts_as_customizable 
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :form
  
  has_many :custom_values
  accepts_nested_attributes_for :custom_values, :allow_destroy => true
  
  named_scope :by_creator, lambda {|user| {:conditions => ["creator_id = ?", user.id] }}
end
