class CreateCustomFields < ActiveRecord::Migration
  def self.up
    create_table :custom_fields do |t|
      t.column "name",         :string
      t.column "description",  :text
      t.column "field_format", :string
      t.column "is_required",  :boolean, :default => false
      t.column "form_id",      :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_fields
  end
end
