class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create table :reviews do |f|
      f.string :content
      f.integer :user_id
      f.integer :movie_id
    end
  end
end
