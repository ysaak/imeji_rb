require 'test_helper'

class HelpPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
