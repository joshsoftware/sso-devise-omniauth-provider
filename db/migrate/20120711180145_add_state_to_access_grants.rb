class AddStateToAccessGrants < ActiveRecord::Migration
  def change
    add_column :access_grants, :state, :string
  end
end
