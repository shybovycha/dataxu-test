require 'test_helper'

class InitiariesControllerTest < ActionController::TestCase
  setup do
    @initiary = initiaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:initiaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create initiary" do
    assert_difference('Initiary.count') do
      post :create, :initiary => @initiary.attributes
    end

    assert_redirected_to initiary_path(assigns(:initiary))
  end

  test "should show initiary" do
    get :show, :id => @initiary.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @initiary.to_param
    assert_response :success
  end

  test "should update initiary" do
    put :update, :id => @initiary.to_param, :initiary => @initiary.attributes
    assert_redirected_to initiary_path(assigns(:initiary))
  end

  test "should destroy initiary" do
    assert_difference('Initiary.count', -1) do
      delete :destroy, :id => @initiary.to_param
    end

    assert_redirected_to initiaries_path
  end
end
