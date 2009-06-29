class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :creator_id
      t.integer :project_id
      t.string  :recipient_email 
      t.string  :recipient_email_body
      t.string  :token
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
