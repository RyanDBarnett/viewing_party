class RemoveMdbIdFromParties < ActiveRecord::Migration[5.2]
  def change
    remove_column :parties, :mdb_id, :integer
  end
end
