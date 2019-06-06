class CreateSelectedKaomoji < ActiveRecord::Migration[5.2]
  def change
    create_table :selected_kaomojis do |t|
      t.string :kaomoji, null: false

      t.index :twitter_identifier, unique: true
    end
  end
end
