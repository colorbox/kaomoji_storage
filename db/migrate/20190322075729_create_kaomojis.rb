class CreateKaomojis < ActiveRecord::Migration[5.2]
  def change
    create_table :kaomojis do |t|
      t.references :tweet, null: false
      t.string :kaomoji, null:false, default: ''

      t.timestamps
    end
  end
end
