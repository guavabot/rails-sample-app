require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title,         "Ivan's Sample App"
    assert_equal full_title("Help"), "Help | Ivan's Sample App"
  end
end