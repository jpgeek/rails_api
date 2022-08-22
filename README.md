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
[HATEOAS](https://en.wikipedia.org/wiki/HATEOAS)
[Why HATEOAS is Useless and what that means for REST](https://medium.com/@andreasreiser94/why-hateoas-is-useless-and-what-that-means-for-rest-a65194471bc8)

Might consider this in the future:
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
## `bcrypt` + `has_secure_password`
## `jwt`
OWASP indicates that JWT is an emerging standard for security tokens:
[OWASP](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html#jwt)

Using HMAC with SHA-512 ("alg" value = "HS512").
Application is a single verifier, so don't need asymmetric keys.

## ref
* [RFC7518](https://www.rfc-editor.org/rfc/rfc7518#section-3.1)
* [hmac sha 512](https://security.stackexchange.com/a/96176/242497)
* [OWASP recommendations](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)
* [StackOverflow Blog Best Practices for REST API Design](https://stackoverflow.blog/2020/03/02/best-practices-for-rest-api-design/)

## JWT implementation
JWT is handled by `jwt_rails`
Wrapped by JwtManager to set defaults, add revocation.


# TODO
Add Pundit auth to controllers
Add json response for auth errors
    render_error_payload(...)

Add Authentication, specs

User, Token responses
Pagination, filtering on resources

