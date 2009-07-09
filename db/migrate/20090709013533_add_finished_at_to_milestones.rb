class AddFinishedAtToMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :finished_at, :datetime
  end

  def self.down                                    
    remove_column :milestones, :finished_at
  end
end
