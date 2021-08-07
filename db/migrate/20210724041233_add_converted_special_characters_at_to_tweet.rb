class AddConvertedSpecialCharactersAtToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :html_special_character_converted_at, :datetime
  end
end
