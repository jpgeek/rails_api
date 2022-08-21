require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /sessions" do
    let(:token) { response_json['jwt'] }
    let(:header) { Base64.decode64(token.split('.')[0]) }
    let(:payload) { Base64.decode64(token.split('.')[1]) }

    context 'when the user has a valid login' do
      it 'redirects to root_path and sets user_id in session' do
        params = { email: user.email, password: user.password }
        post(api_v1_sessions_path, params: params, as: :json)
        expect(JSON.parse(payload)).to include('user_id' => user.id)
        expect(JSON.parse(header)).to include('alg' => 'HS512')
      end
    end

    context 'when the user has an invalid login' do
      before(:each) do 
        params = { email: user.email, password: 'wrong' }
        post(api_v1_sessions_path, params: params, as: :json)
      end

      it 'does not return a jwt' do
        expect(token).to be_nil
      end

      it 'includes the error message' do
        expected = {
          'title' => 'Authentication failed',
          'detail' => 'Email or password was incorrect',
          'code' => 'authentication_failed'
        }
        expect(response_json).to include(expected)
      end
    end
  end

  describe "DESTROY /session" do
    context 'when the user is logged in' do
      let(:jwt) { jwt_for(user) }
      before(:each) do
        delete logout_api_v1_sessions_path,
          headers: { 'Authorization' => jwt },
          as: :json
      end

      # access a page that requires authentication
      it 'gets an error when trying to authenticate'

      it 'adds the key to the revokation list' do
        expect(JwtManager.revoked?(jwt)).to be_truthy
      end
    end
  end
end
