class Tweet < ApplicationRecord
  belongs_to :user
  has_many :kaomojis, dependent: :destroy

  scope :not_bracket_filtered, -> { where(bracket_filtered_at: nil) }

  def create_raw_kaomojis
    duped = text.dup
    kaomoji_regexp = /[（(].+?[)）]/
    kaomojis.create(kaomoji: duped.slice!( kaomoji_regexp )) while duped.slice( kaomoji_regexp )
  end

  def raw_kaomojis
    duped = text.dup
    kaomoji_regexp = /[（(].+?[)）]/
    kaomojis_array = []
    kaomojis_array << (duped.slice!( kaomoji_regexp )) while duped.slice( kaomoji_regexp )
    kaomojis_array
  end

  def bracketed_japanese
    duped = text.dup
    japanese_regexp = /[(（](?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々]){2,}[）)]/
    japanese = []
    japanese << (duped.slice!( japanese_regexp )) while duped.slice( japanese_regexp )
    japanese
  end

  def bracket_filter(str)
    duped = text.dup
    kaomoji_regexp = /[(（].+?[）)]/
    kaomojis = []
    kaomojis << (duped.slice!( kaomoji_regexp )) while duped.slice( kaomoji_regexp )
    kaomojis
  end
end
