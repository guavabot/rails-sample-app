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

end
