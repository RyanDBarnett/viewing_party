class RemoveMovieTitleFromParties < ActiveRecord::Migration[5.2]
  def change
    remove_column :parties, :movie_title, :string
  end
end
