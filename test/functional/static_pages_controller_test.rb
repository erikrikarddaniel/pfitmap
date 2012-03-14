require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end
  
  test "h1 should be Home" do
    get :home
    assert_select 'h1', 'Home'
  end

  test "h1 should be Help" do
    get :help
    assert_select 'h1', 'Help'
  end

  #  test "for help, contact RNRdb" do 
  #   get :help
  #  assert_select 'p', 'contact RNRdb'
  #end
  test "h1 should be Contact" do
    get :contact
    assert_select 'h1', "Contact"
  end

  test "should route to Contact" do
    assert_generates("/static_pages/contact", 
                     :controller => "static_pages",
                     :action => "contact")
  end

end
