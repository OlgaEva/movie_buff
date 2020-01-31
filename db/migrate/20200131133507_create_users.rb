class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create table :users do |f|
      f.string :name
    end
  end
end
