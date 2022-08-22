json.user do
  json.extract! user, :id, :email, :first_name, :last_name
  json.links do
    json.self api_v1_user_url(user, format: :json)
  end
end
