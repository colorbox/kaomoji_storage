class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :twitter_identifier, null: false
      t.string :screen_name, null: false
      t.string :name, null: false
      t.string :desription, null:false, default: ''

      t.timestamps

      t.index :twitter_identifier, unique: true
    end
  end
end
