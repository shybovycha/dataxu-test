require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get log_in" do
    get :log_in
    assert_response :success
  end

  test "should get log_out" do
    get :log_out
    assert_response :success
  end

end
