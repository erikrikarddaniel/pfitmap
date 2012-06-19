Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
end
