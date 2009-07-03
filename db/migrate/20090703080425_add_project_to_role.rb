class AddProjectToRole < ActiveRecord::Migration
  def self.up   
    add_column :roles, :project_id, :integer     
    
    add_column :project_users, :role_id, :integer
  end

  def self.down
  end
end
