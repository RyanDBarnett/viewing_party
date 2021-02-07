class AddMdbIdToParty < ActiveRecord::Migration[5.2]
  def change
    add_column :parties, :mdb_id, :integer
  end
end
