require 'rails_helper'

RSpec.describe 'Zones API', type: :request do
  # GET /zones
  let!(:zones) { create_list(:zone, 9)}
  let(:zone_id) { zones.first.id}

  describe 'GET /zones' do
    before { get '/zones' }

    it 'returns zones' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq(9)
    end

    it 'returns success status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /zones/:id' do
    before { get "/zones/#{zone_id}" }

    context 'when the zone exists' do
      it 'returns the zone' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['id']).to eq(zone_id)
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'when the zone does not exist' do
      let(:zone_id) { 900 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Zone/)
      end
    end

    describe 'POST /zones' do
      let(:valid_attributes) { {name: 'Valid Zone'} }
      context 'when the request is valid' do
        before { post '/zones', params: valid_attributes}

        it 'creates a zone' do
          expect(JSON.parse(response.body)['name']).to eq('Valid Zone')
        end
        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

      end
      context 'when the request is invalid' do
        before { post '/zones', params: { name: ''} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed/)
        end
      end
    end
    describe 'PUT /zones/:id' do
      let(:put_attributes) { { name: 'Putt putt zone'} }
      context 'when the zone exists' do
        before { put "/zones/#{zone_id}", params: put_attributes}
        it 'updates the zone' do
          expect(response.body).to be_empty
        end
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

      end
    end
    describe 'DELETE /zones/:id' do
      before { delete "/zones/#{zone_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
