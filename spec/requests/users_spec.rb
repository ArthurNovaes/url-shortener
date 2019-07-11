require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:users) { create_list(:user, 10) }
  let(:user_01) { users.first }
  let(:json) { JSON.parse(response.body) }

  describe 'POST /users' do
    let(:valid_attributes) { { login: 'user01' } }

    context 'when the request is valid' do
      before do
        post '/users', params: valid_attributes
        json
      end

      it 'creates a user' do
        expect(json['login']).to eq('user01')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { login: user_01.login } }

      it 'returns status code 409' do
        expect(response).to have_http_status(409)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: This user already exists/)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_01.id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end

