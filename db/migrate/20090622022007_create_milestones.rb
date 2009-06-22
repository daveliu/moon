class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :creator_id
      t.string :title
      t.integer :receiver_id    
      t.datetime :due
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
