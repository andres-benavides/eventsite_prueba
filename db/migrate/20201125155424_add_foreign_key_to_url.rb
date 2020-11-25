class AddForeignKeyToUrl < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :urls, :users
  end
end
