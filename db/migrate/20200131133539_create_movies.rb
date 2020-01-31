class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |table|
      table.string :title
    end
  end
end
