require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  test 'fetch_kaomoji' do

    assert_equal tweets(:one).kaomojis, ['(-3-)', '(・3・)']
  end
end
