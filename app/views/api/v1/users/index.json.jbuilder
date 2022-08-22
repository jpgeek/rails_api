# frozen_string_literal: true

json.users do
  json.array! @users, partial: "api/v1/users/user", as: :user
end
