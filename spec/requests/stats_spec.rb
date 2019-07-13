require 'rails_helper'

RSpec.describe 'Stats API', type: :request do
  let!(:urls) { create_list(:url, 11) }
  let!(:user) { create :user }
  let(:url_01) { urls.first }

  let(:hit)    { create :hit, url_id: url_01.id, user_id: user.id }
  let(:hit_02) { create :hit, url_id: url_01.id, user_id: user.id }
  let(:hit_03) { create :hit, url_id: urls.second.id }

  let(:json) { JSON.parse(response.body) }

  describe 'GET /stats/:id' do

    context 'when request is valid' do
      before do
        hit
        hit_02
        get "/stats/#{url_01.id}"
      end

      it 'returns status 200 ok' do
        expect(response).to have_http_status(200)
      end

      it do
        expect(json).to include('url' => url_01.original )
          .and include('hits' => 2)
      end
    end

    context 'when request is invalid' do
      before do
        get "/stats/999"
      end

      it 'returns status 404 not_found' do
        expect(response).to have_http_status(404)
      end

      it { expect(json).to include('message' => "Couldn't find Url with 'id'=999" ) }
    end
  end

  describe 'GET /stats/' do

    context 'when request is valid' do
      before do
        hit
        hit_02
        hit_03
        get '/stats/'
      end

      it { expect(response).to have_http_status(200) }

      it 'return correct data' do
        expect(json).to include('hits' => 3)
                    .and include('urlCount' => 11)
        expect(json['topUrls'].size).to eq 10
        expect(json['topUrls'].first['id']).to eq url_01.id
      end
    end
  end
end
