class RemoveWithBracketsColumnFromKaomoji < ActiveRecord::Migration[5.2]
  def change
    remove_column :kaomojis, :with_bracket, :text
  end
end
