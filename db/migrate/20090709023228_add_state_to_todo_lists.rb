class AddStateToTodoLists < ActiveRecord::Migration
  def self.up
    add_column :todo_lists, :state, :string
  end

  def self.down                            
    remove_column :todo_lists, :state
  end
end
