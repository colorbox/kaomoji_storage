class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.references :user, null: false
      t.string :tweet_identifier, null:false, default: false
      t.string :text, null:false, default: ''

      t.timestamps
    end
  end
end
