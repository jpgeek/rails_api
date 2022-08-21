module ApiHelpers
  def response_json
    JSON.parse(response.body)
  end

  def jwt_for(user)
    JwtManager.encode({user_id: user.id})
  end

  def auth_header_for(user)
    { 'Authorization' => "Bearer #{jwt_for(user)}" }
  end
end
