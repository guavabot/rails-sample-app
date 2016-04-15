# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  picture    :string
#

require 'test_helper'

class TweetTest < ActiveSupport::TestCase

  def setup
    @user = users(:miguel)
    @tweet = @user.tweets.build(content: 'Tweeting')
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

  test 'order should be by most recent first' do
    assert_equal tweets(:most_recent), Tweet.first
  end

end
