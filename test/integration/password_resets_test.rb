require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:miguel)
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Token generation
    ##################
    # Invalid email
    post password_resets_path, password_reset: { email: 'not@example.com' }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not flash.empty?
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.count
    assert_redirected_to root_url

    # Token validation
    ##################
    user = assigns(:user)

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: 'not@example.com')
    assert_redirected_to root_url

    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # Wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Valid user and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # Password change
    ##################
    # Invalid password confirmation
    patch password_reset_path(user.reset_token),
        email: user.email,
        user: { password: 'foobar', password_confirmation: 'foo' }
    assert_select 'div#error_explanation'

    # Empty password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: '', password_confirmation: '' }
    assert_select 'div#error_explanation'

    # Valid password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'foobar', password_confirmation: 'foobar' }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test 'expired_token' do
    post password_resets_path, password_reset: { email: @user.email }

    user = assigns(:user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)

    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'foobar', password_confirmation: 'foobar' }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end

end
