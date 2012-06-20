module IntegrationSpecHelper
  def login_with_oauth(service = :open_id)
    visit "/auth/#{service}"
  end
end
