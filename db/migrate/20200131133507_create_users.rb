class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |table|
      table.string :name
    end
  end
end
