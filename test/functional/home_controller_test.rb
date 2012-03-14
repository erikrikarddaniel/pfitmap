require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should have content hello" do
    get :index
    assert_select "h1", "Hello, pfitmap!"
  end
end
