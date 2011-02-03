class CreateClientApplications < ActiveRecord::Migration
  def self.up
    create_table :client_applications do |t|
      t.string :name
      t.string :app_id
      t.string :app_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :client_applications
  end
end
