class Project < ActiveRecord::Base
  has_many :milestones
  has_many :messages
  has_many :todo_lists
  has_many :assets
  has_many :timeline_events
  has_many :time_entries
  has_many :project_users
  has_many :users,  :through => :project_users
  has_many :categories
  has_many :forms
  has_many :roles
  
  accepts_nested_attributes_for :project_users
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  after_save :add_admin
  

  
  
  private
  def add_admin
    users << creator
  end
end
