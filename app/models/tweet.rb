class Tweet < ApplicationRecord
  belongs_to :user

  def kaomojis
    duped = text.dup
    kaomoji_regexp = /\(.+?\)/
    kaomojis = []
    kaomojis << (duped.slice!( kaomoji_regexp )) while duped.slice( kaomoji_regexp )
    kaomojis
  end

  def bracket_filter(str)
    duped = text.dup
    kaomoji_regexp = /\(.+?\)/
    kaomojis = []
    kaomojis << (duped.slice!( kaomoji_regexp )) while duped.slice( kaomoji_regexp )
    kaomojis
  end
end
