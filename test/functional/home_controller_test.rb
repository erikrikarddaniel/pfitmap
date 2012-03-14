require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should have h1 Welcome" do
    get :index
    assert_select "h1", "Welcome to RNRdb"
  end
  test "should not capitalize title" do
    get :index
    assert_select "logo", "RNRdb"
  end
end
