class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |table|
      table.string :name
    end
  end
end




# class CreateUser < ActiveRecord::Migration[5.2]
#   def change
#     create_table :users do |t|
#       t.string :name
#     end
#   end
# end