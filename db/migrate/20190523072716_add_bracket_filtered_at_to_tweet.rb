class UpdateTweetBracketFilteredToBracketFilteredAt < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :bracket_filtered_at, :datetime
  end
end
