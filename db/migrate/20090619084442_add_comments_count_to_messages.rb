class AddCommentsCountToMessages < ActiveRecord::Migration
  def self.up 
    add_column :messages, :comments_count, :integer, :default => 0
  end

  def self.down
  end
end
