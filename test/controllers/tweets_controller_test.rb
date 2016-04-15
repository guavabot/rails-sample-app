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

class TweetsControllerTest < ActionController::TestCase

  def setup
    @tweet = tweets(:orange)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Tweet.count' do
      post :create, tweet: { content: 'Lorem Ipsuming'}
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Tweet.count' do
      delete :destroy, id: @tweet
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy for wrong tweet' do
    log_in_as(users(:miguel))
    tweet = tweets(:ants)
    assert_no_difference 'Tweet.count' do
      delete :destroy, id: tweet
    end
    assert_redirected_to root_url
  end

end
