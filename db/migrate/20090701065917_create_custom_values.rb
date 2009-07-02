class CreateCustomValues < ActiveRecord::Migration
  def self.up
    create_table :custom_values do |t|
      # t.column "customized_type", :string, :limit => 30, :default => "", :null => false
      # t.column "customized_id",   :integer, :default => 0, :null => false
      t.column "custom_field_id", :integer, :default => 0, :null => false
      t.column "value", :text                                              
      t.column "response_id", :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_values
  end
end
