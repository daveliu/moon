class AddCommentsCount < ActiveRecord::Migration
  def self.up
    add_column :milestones,  :comments_count, :integer  
  end

  def self.down
  end
end
