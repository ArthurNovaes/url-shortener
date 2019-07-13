require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:users) { create_list(:user, 10) }
  let(:user_01) { users.first }
  let(:user_02) { users.second }
  let(:json) { JSON.parse(response.body) }

  let(:url_01) { create :url }
  let(:url_02) { create :url }

  let(:hit_01) { create :hit, user_id: user_01.id, url_id: url_01.id }
  let(:hit_02) { create :hit, user_id: user_01.id, url_id: url_01.id }
  let(:hit_03) { create :hit, user_id: user_01.id, url_id: url_01.id }

  let(:hit_04) { create :hit, user_id: user_02.id, url_id: url_02.id }

  let(:hit_05) { create :hit, user_id: user_02.id, url_id: url_01.id }
  let(:hit_06) { create :hit, user_id: user_02.id, url_id: url_01.id }

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

  describe 'GET /users/:id/stats' do
    let(:user_id) { { } }
    let(:setup) do
      url_01
      url_02
      hit_01
      hit_02
      hit_03
      hit_04
      hit_05
      hit_06
    end

    before do
      setup
      get "/users/#{user_id}/stats"
    end

    context 'when user exists' do
      let(:user_id) { user_01.id }

      it { expect(response).to have_http_status(200) }

      it 'return correct data scoped by user' do
        expect(json).to include('hits' => 3)
                    .and include('urlCount' => 1)
        expect(json['topUrls'].size).to eq 1
        expect(json['topUrls'].first['hits']).to eq 3
      end
    end

    context 'when user not exists' do
      let(:user_id) { 999 }

      it { expect(response).to have_http_status(404) }
    end
  end
end

