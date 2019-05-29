class AddHasBracketColumnToKaomoji < ActiveRecord::Migration[5.2]
  def change
    add_column :kaomojis, :has_bracket, :booelan
  end
end
