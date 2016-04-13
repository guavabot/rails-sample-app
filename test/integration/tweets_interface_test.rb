require 'test_helper'

class TweetsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:miguel)
  end

  test 'tweet interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    #Invalid submission
    assert_no_difference 'Tweet.count' do
      post tweets_path, tweet: { content: '' }
    end
    assert_select 'div#error_explanation'

    #Valid submission
    content = 'This post is awe-worthy'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Tweet.count', 1 do
      post tweets_path, tweet: { content: content, picture: picture }
    end
    assert @user.tweets.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    #Delete a post
    assert_select 'a', text: 'delete'
    first_tweet = @user.tweets.paginate(page: 1).first
    assert_difference 'Tweet.count', -1 do
      delete tweet_path(first_tweet)
    end

    #Visit different user
    get user_path(users(:samuel))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'tweet sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match '34 tweets', response.body

    # User with zero tweets
    other_user = users(:lonely)
    log_in_as(other_user)
    get root_path
    assert_match '0 tweets', response.body
    other_user.tweets.create!(content: "A tweet")
    get root_path
    assert_match '1 tweet', response.body
  end

end
