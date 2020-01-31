class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create table :movies do |f|
      f.string :title
    end
  end
end
