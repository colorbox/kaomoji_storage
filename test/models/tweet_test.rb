require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  test 'get kaomoji index' do
    assert_equal 8, tweets(:two).get_kaomoji_right_side(4)
    assert_equal 4 , tweets(:two).get_kaomoji_left_side(8)
    assert_equal ['(-3-)', '(・3・)'] , tweets(:two).get_unicode_kaomojis
  end
end
