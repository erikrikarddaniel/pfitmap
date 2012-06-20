module IntegrationSpecHelper
  def login_with_oauth(service = :open_id)
    visit "/auth/#{service}"
  end

  def make_mock_admin
    @User = User.new(name: 'Bob Example', email: 'bob@example.com')
    @User.uid = '12345'
    @User.provider = 'open_id'
    @User.role = 'admin'
    @User.save
  end
end
