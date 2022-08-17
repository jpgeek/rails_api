module LocalJwt
  # Use HS512.
  # Key is 256 character long hex string. 
  # (256 characters X 4 bits per hex character = 1024 bit key)
  # openssl rand -hex 256
  class Application < Rails::Application
    Rails.configuration.x.jwt.cryptographic_algorithm = 'HS512'
    Rails.configuration.x.jwt.iss = 'jwt.example.com'
    Rails.configuration.x.jwt.aud = 'jwt.example.com'
  end
end
