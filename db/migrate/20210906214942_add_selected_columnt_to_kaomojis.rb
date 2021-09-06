class AddSelectedColumntToKaomojis < ActiveRecord::Migration[5.2]
  def change
    add_column :kaomojis, :selected, :boolean
  end
end
