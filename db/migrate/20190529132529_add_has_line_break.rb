class AddHasLineBreak < ActiveRecord::Migration[5.2]
  def change
    add_column :kaomojis, :has_line_break, :boolean
  end
end
