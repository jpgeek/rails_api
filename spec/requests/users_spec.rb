require 'rails_helper'
RSpec.describe "/users", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) do
    attributes_for(:user).merge(email: nil, first_name: nil)
  end
  let(:user) { create(:user) }
  let(:user2) { create(:user, first_name: 'Doug') }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) { auth_header_for(user) }
  let(:invalid_headers) { { mac_n: 'cheese' } }

  describe "GET /index" do
    it "renders a successful response" do
      user
      user2
      get api_v1_users_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response_json['users'].count).to eq(1)
    end
  end

  describe "GET /show" do
    context 'without jwt' do
      it "returns an error" do
        get api_v1_user_url(user), headers: invalid_headers, as: :json
        expect(response).not_to be_successful
        expect(response_json['error']).to include(
          "code"=>"user_not_authorized",
          "status"=>403
        )
      end
    end
    context 'with jwt' do
      it "returns the user" do
        get api_v1_user_url(user), headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(response_json['user']).to include(
          'email' => user.email,
          'first_name' => user.first_name,
          'last_name' => user.last_name,
        )
      end
    end
  end

  describe "POST /create" do
    it 'cannot set its role'

    # create does NOT require authentication.
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post api_v1_users_url,
               params: { user: valid_attributes }, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post api_v1_users_url,
             params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type)
          .to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post api_v1_users_url,
               params: { user: invalid_attributes },
               as: :json
        }.to change(User, :count).by(0)
      end

      it "returns an error" do
        post api_v1_users_url,
          params: { user: invalid_attributes },
          as: :json
        expect(response_json['errors']).to include(
          {"email" => ["can't be blank"], "first_name" => ["can't be blank"]}
        )
      end

      it "renders a JSON response with errors for the new user" do
        post api_v1_users_url,
             params: { user: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          first_name: 'Alan',
          email: 'alan.smith@example.com'
        } 
      end

      it "updates the requested user" do
        patch api_v1_user_url(user),
              params: { user: new_attributes }, headers: valid_headers, as: :json
        user.reload
        expect(response_json['user']).to include( new_attributes.stringify_keys)
        expect(response_json['user']).to include( 'last_name' => user.last_name)
      end


      it "renders a JSON response with the user" do
        patch api_v1_user_url(user),
              params: { user: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it 'cannot change its role'
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the user" do
        patch api_v1_user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      user
      expect {
        delete api_v1_user_url(user), headers: valid_headers, as: :json
      }.to change(User, :count).by(-1)
    end
  end
end
