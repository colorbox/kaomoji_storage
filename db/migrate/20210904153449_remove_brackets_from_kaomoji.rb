class RemoveBracketsFromKaomoji < ActiveRecord::Migration[5.2]
  def change
    remove_column :kaomojis, :has_line_break, :boolean
    add_column :kaomojis, :has_line_break, :boolean

    remove_column :kaomojis, :has_bracket, :boolean
    add_column :kaomojis, :has_bracket, :boolean
  end
end
