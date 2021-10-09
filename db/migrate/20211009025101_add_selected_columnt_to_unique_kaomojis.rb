class AddSelectedColumntToUniqueKaomojis < ActiveRecord::Migration[5.2]
  def change
    add_column :unique_kaomojis, :selected, :boolean, default: false
  end
end
