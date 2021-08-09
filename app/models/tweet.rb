class Tweet < ApplicationRecord
  belongs_to :user
  has_many :kaomojis, dependent: :destroy

  scope :not_bracket_filtered, -> { where(bracket_filtered_at: nil) }
  scope :bracket_filtered, -> { where.not(bracket_filtered_at: nil) }

  scope :not_unicode_filtered, -> { where(unicode_filtered_at: nil) }
  scope :unicode_filtered, -> { where.not(unicode_filtered_at: nil) }

  scope :not_html_special_characters_converted, -> { where(html_special_character_converted_at: nil) }

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

  def kaomoji_parts?(chr)
    kaomoji_group_categories = %w(Pc Pd Pe Pf Pi Po Ps Sc Sk Sm So)
    japanese_group = %w(Basic\ Latin Hiragana CJK\ Unified\ Ideographs Fullwidth\ ASCII\ Variants)
    parts = %w(\( \) （ ） ・)
    return !japanese_group.include?(Unicode::Blocks.blocks(chr).first) || kaomoji_group_categories.include?(Unicode::Categories.categories(chr).first)
  end

  def normal_char?(chr)
    normal_char_blocks = %w(Lc Ll Lm Lo Lt Lu Nd Nl)
    target_block = Unicode::Categories.categories(chr)
    normal_char_blocks.include?(target_block.first)
  end

  def create_unicode_kaomojis
    get_unicode_kaomojis.each do |kaomoji|
      kaomojis.create(kaomoji: kaomoji) unless kaomojis.map(&:kaomoji).include?(kaomoji)
    end
  end

  def get_unicode_kaomojis
    return [] if text.chars.length.zero?

    kaomojis = (0..text.chars.size-1).map{|i| get_one_unicode_kaomoji_at_index(i) if kaomoji_parts?(text.chars[i]) }.uniq.compact
    kaomojis.select{|k|valid_kaomoji?(k)}
  end

  def get_one_unicode_kaomoji_at_index(index)
    start = get_kaomoji_left_side(index)
    last = get_kaomoji_right_side(index)
    text.chars[start..last].join
  end

  THRESHOLD=2

  def get_kaomoji_right_side(start_index)
    return start_index if start_index==text.chars.length-1
    last = start_index
    count = 0
    text.chars[start_index..text.length-1].each_with_index do |chr, index|
      if kaomoji_parts?(chr)
        count = 0
        last = start_index + index
      elsif normal_char?(chr)
        count += 1
      end
      return last if count > THRESHOLD || index == text.chars[start_index..text.length-1].length - 1
    end
  end

  def get_kaomoji_left_side(start_index)
    return 0 if start_index.zero?
    first = start_index
    count = 0
    text.chars[0..start_index].reverse.each_with_index do |chr, index|
      if kaomoji_parts?(chr)
        count = 0
        first = start_index - index
      elsif normal_char?(chr)
        count += 1
      end
      return first if count > THRESHOLD || index == start_index-1
    end
  end

  def unicode_kaomojis(threshold=2)
    kaomojis = []
    current=[]
    count=0
    text.split('').each do |chr|
      if kaomoji_parts?(chr)
        current.push(chr)
        count=0
      else
        count+=1
      end

      pp [chr,count]
      if count > threshold
        kaomoji = current.join
        kaomojis.push(kaomoji) if valid_kaomoji?(kaomoji)
        current=[]
        count=0
      end
    end

    if current.count > 0
      kaomoji = current.join
      kaomojis.push(kaomoji) if valid_kaomoji?(kaomoji)
    end

    kaomojis
  end

  HTML_SPECIAL_CHARACTERS_CONVERT = {
    '&lt;' => '<',
    '&gt;' => '>',
    '&amp;' => '&'
  }.freeze

  def convert_html_special_characters
    HTML_SPECIAL_CHARACTERS_CONVERT.each do |from, to|
      self.text = text.gsub(from, to)
    end
    self.save
  end

  def valid_kaomoji?(kaomoji)
    kaomoji.length > 3 && !half_of_normal_chars(kaomoji) && !part_of_tico_address?(kaomoji)
  end

  def half_of_normal_chars(str)
    normal_chars = %w(Lc Ll Lm Lo Lt Lu Nd Nl)
    normal_words_count =str.split('').map{|chr|Unicode::Categories.categories(chr).map{|block|normal_chars.include?(block)}.any? ? 1 : 0}.sum.to_f
    all_count = str.length.to_f
    result = (normal_words_count / all_count) > 0.5
    result
  end

  def part_of_tico_address?(kaomoji)
    kaomoji.include?('://t.c')
  end
end
