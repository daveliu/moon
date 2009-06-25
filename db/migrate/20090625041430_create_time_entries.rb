class CreateTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :time_entries do |t|
      t.datetime :done_date
      t.float    :hours
      t.text     :description
      t.integer  :todo_id
      t.integer  :receiver_id
      t.integer  :creator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :time_entries
  end
end
