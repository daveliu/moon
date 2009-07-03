class Role < ActiveRecord::Base
  acts_as_authorization_role                
  
  has_and_belongs_to_many :users
  belongs_to :project
  
  PROJECT_ROLES = %w[manager coder designer]
  
  
end
