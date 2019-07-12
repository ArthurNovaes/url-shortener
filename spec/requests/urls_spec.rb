require 'rails_helper'

RSpec.describe 'Urls API', type: :request do
  let!(:urls) { create_list(:url, 10) }
  let!(:user) { create :user }
  let(:url_01) { urls.first }

  let(:hit)    { create :hit, url_id: url_01.id }
  let(:hit_02) { create :hit, url_id: url_01.id }

  let(:json) { JSON.parse(response.body) }

  describe 'GET /urls/:id' do

    context 'when request is valid' do
      let(:user_params) { { login: user.login } }

      before do
        get "/urls/#{url_01.id}", params: user_params
      end

      context 'When url and user exists' do
        it 'returns status 301 redirect' do
          expect(response).to have_http_status(301)
        end

        it 'create one hit' do
          expect(Hit.count).to eq 1
          expect(Hit.first.user_id).to be == user.id
        end
      end

      context 'When pass only url_id' do
        let(:user_params) { { } }

        it 'returns status 301 redirect' do
          expect(response).to have_http_status(301)
        end

        it 'create one hit' do
          expect(Hit.count).to eq 1
          expect(Hit.first.user_id).to be_nil
        end
      end
    end

    context 'when url does not exists' do
      before { get "/urls/2" }

      it 'return 404 not found' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /urls' do
    let(:attributes) { { } }
    let(:setup) do
      hit
      hit_02
    end

    before do
      setup
      post '/urls', params: attributes
      json
    end

    context 'when url does not exists' do
      let(:attributes) { { url: 'https://github.com/stympy/faker' } }

      it 'return object of a created url' do
        expect(json).to include('url' => 'https://github.com/stympy/faker' )
                    .and include('hits' => 0)
        expect(json).not_to include('message' => 'This url already exists')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when url already exists' do
      let(:attributes) { { url: url_01.original } }

      it 'return object of a existent url' do
        expect(json).to include('url' => url_01.original )
                    .and include('hits' => 2)
                    .and include('message' => 'This url already exists')
      end

      it 'returns status code 302 found' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE /urls/:id' do
    context 'when url exists' do
      before { delete "/urls/#{url_01.id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when url does not exists' do
      before { delete "/urls/30" }

      it 'return 404 not found' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
