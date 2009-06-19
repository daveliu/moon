class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :body
      t.string :title
      t.integer :category_id, :milestone_id
      t.integer :creator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
