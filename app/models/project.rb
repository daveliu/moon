class Project < ActiveRecord::Base
  has_many :milestones, :dependent => :destroy 
  has_many :messages, :dependent => :destroy
  has_many :todo_lists, :dependent => :destroy
  has_many :assets, :dependent => :destroy
  has_many :timeline_events, :dependent => :destroy
  has_many :time_entries, :dependent => :destroy
  has_many :project_users, :dependent => :destroy
  has_many :users,  :through => :project_users
  has_many :categories, :dependent => :destroy
  has_many :forms, :dependent => :destroy
  has_many :roles, :dependent => :destroy
  
  accepts_nested_attributes_for :project_users
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  after_save :add_admin
  

  
  
  private
  def add_admin
    users << creator
  end
end
