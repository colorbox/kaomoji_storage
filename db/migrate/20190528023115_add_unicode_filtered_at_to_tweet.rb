class AddUnicodeFilteredAtToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :unicode_filtered_at, :datetime
  end
end
