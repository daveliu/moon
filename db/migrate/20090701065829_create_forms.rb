class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string  :name
      t.text    :description
      t.integer :creator_id
      t.integer :project_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :forms
  end
end
