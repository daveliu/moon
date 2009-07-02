class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :form_id
      t.integer :creator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
