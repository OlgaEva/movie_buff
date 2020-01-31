class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |table|
      table.string :content
      table.integer :user_id
      table.integer :movie_id
    end
  end
end
