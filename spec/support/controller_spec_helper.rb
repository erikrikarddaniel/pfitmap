module ControllerSpecHelper
  def get_admin_user
    make_mock_admin
    login_with_oauth
    @user = User.first
  end
end
