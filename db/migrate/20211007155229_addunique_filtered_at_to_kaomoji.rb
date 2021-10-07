class AdduniqueFilteredAtToKaomoji < ActiveRecord::Migration[5.2]
  def change
    add_column :kaomojis, :unique_filtered_at, :datetime
    add_index :kaomojis, :unique_filtered_at
  end
end
