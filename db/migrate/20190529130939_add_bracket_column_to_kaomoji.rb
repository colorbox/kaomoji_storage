class AddBracketColumnToKaomoji < ActiveRecord::Migration[5.2]
  def change
    add_column :kaomojis, :with_bracket, :text
  end
end
