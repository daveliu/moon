class CreateTodoLists < ActiveRecord::Migration
  def self.up
    create_table :todo_lists do |t|
      t.string  :title
      t.text    :description
      t.integer :milestone_id
      t.integer :creator_id
      t.integer :todos_count
      t.timestamps
    end
  end

  def self.down
    drop_table :todo_lists
  end
end
