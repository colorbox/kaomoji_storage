class AddHasBracketsColumnToKaomoji < ActiveRecord::Migration[5.2]
  def change
    add_column :kaomojis, :has_brackets, :boolean
  end
end
