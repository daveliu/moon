class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
       t.string   "name",              :limit => 40
       t.string   "authorizable_type", :limit => 40
       t.integer  "authorizable_id" 
       t.datetime "created_at" 
       t.datetime "updated_at" 
      t.timestamps
    end
    
    create_table "roles_users", :id => false, :force => true do |t|
      t.integer  "user_id" 
      t.integer  "role_id" 
      t.datetime "created_at" 
      t.datetime "updated_at" 
    end
    
  end

  def self.down
    drop_table :roles
  end
end
