class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |table|
      table.string :title
    end
  end
end
