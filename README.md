# Rails Api
A Ruby On Rails template for an API only application.   Contains authorization,
authentication and test framework setup.

# Rails
Version 7.0

# Database
MySQL

# Style
Style is enforced with Rubocop with Rubocop Rails configuration.

# JSON
Follows JSON:API formatting.
[JSON:API](https://jsonapi.org/)


# Testing
Rspec, included via rspec-rails.
`factory-bot`
`shoulda-matchers`
`pundit-matchers`

# Authorization
`pundit`

# Authentication
## bcrypt + `has_secure_password`
## `jwt`
OWASP indicates that JWT is an emerging standard for security tokens:
    https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html#jwt

Using HMAC with SHA-512 ("alg" value = "HS512").
Application is a single verifier, so don't need asymmetric keys.


ref:
      https://www.rfc-editor.org/rfc/rfc7518#section-3.1
      https://security.stackexchange.com/a/96176/242497

      https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html

# JWT
JWT is handled by `jwt_rails`


# TODO
Add Authentication, specs
Add User model
Add Pundit for user
