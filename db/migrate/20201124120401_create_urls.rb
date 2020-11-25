class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.text :url
      t.text :short_code
      t.string :alexa_rank
      t.integer :counter
      t.string :domain

      t.timestamps
    end
  end
end
