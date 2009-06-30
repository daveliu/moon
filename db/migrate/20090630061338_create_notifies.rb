class CreateNotifies < ActiveRecord::Migration
  def self.up
    create_table :notifies do |t|
      t.integer :user_id
      t.string  :notifiable_type
      t.integer :notifiable_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :notifies
  end
end
