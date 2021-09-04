class AddIndexOnKaomojiInKaomoji < ActiveRecord::Migration[5.2]
  def change
    add_index :kaomojis, :kaomoji
  end
end
