class User < ApplicationRecord
  has_many :tweets, dependent: :destroy

  scope :not_fetch, -> { includes(:tweets).where(tweets: {id:nil}) }
end
