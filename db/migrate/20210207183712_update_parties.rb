class UpdateParties < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:parties, :movie, foreign_key: true)
  end
end
