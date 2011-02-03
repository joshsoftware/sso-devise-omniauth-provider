class CreateAccessGrants < ActiveRecord::Migration
  def self.up
    create_table :access_grants do |t|
      t.string :code
      t.string :access_token
      t.string :refresh_token
      t.datetime :access_token_expires_at
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :access_grants
  end
end
