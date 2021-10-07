class CreateUniqueKaomojis < ActiveRecord::Migration[5.2]
  def change
    create_table :unique_kaomojis do |t|
      t.text :kaomoji, null: false
      t.index :kaomoji, unique: true

      t.timestamps
    end
  end
end
