class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.text    :body
      t.integer :todo_list_id
      t.integer :creator_id
      t.integer :receiver_id
      t.integer :comments_count
      t.string  :state
      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
