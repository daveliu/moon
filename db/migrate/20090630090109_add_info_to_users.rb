class AddInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :skype,    :string
    add_column :users, :phone,    :string
    add_column :users, :birthday, :datetime
    add_column :users, :title,    :string
  end

  def self.down
  end
end
