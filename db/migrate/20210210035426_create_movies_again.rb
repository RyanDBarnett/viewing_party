class CreateMoviesAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :mdb_id
      t.string :title

      t.timestamps
    end
  end
end
