require 'test_helper'

class TweetTest < ActiveSupport::TestCase

  def setup
    @user = users(:miguel)
    @tweet = Tweet.new(content: 'Tweeting', user_id: @user.id)
  end

  test 'Tweet should be valid' do
    assert @tweet.valid?
  end

  test 'user id should be present' do
    @tweet.user_id = nil
    assert_not @tweet.valid?
  end

  test 'content should be present' do
    @tweet.content = '   '
    assert_not @tweet.valid?
  end

  test 'max content length should be 140 characters' do
    @tweet.content = 'a' * 141
    assert_not @tweet.valid?
  end

end
