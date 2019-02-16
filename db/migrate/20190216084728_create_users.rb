class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :twitter_identifier, null: false
      t.string :screen_name, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
