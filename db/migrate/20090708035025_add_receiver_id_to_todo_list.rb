class AddReceiverIdToTodoList < ActiveRecord::Migration
  def self.up
    add_column :todo_lists, :receiver_id, :integer
  end

  def self.down                                   
    remove_column :todo_lists, :receiver_id
  end
end
