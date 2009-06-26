class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string   "name",                         :limit => 50
      t.text     "description"
      t.integer  "creator_id"
      t.timestamps
    end                     
    
    
    add_column :todo_lists,   :project_id, :integer
    add_column :milestones,   :project_id, :integer
    add_column :time_entries, :project_id, :integer  
    add_column :assets,       :project_id, :integer
    add_column :timeline_events, :project_id, :integer
    add_column :messages,     :project_id, :integer   
    add_column :categories,   :project_id, :integer
  end

  def self.down
    drop_table :projects
  end
end
