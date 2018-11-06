require 'rails_helper'

RSpec.describe 'Records API' do
  let!(:zone) { create(:zone) }
  let!(:records) { create_list(:record, 9 , zone_id: zone.id) }
  let(:zone_id) { zone.id }
  let(:id) { records.first.id }

  describe 'GET /zones/:zone_id/records' do
    before { get "/zones/#{zone_id}/records" }

    context 'when record exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all records' do
        json = JSON.parse(response.body)
        expect(json.size).to eq(9)
      end
    end
    context 'when record does not exist' do
      let(:zone_id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Zone/)
      end
    end
  end
  describe 'GET /zones/:zone_id/records/:id' do
    before { get "/zones/#{zone_id}/records/#{id}" }

    context 'when record exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the record' do
        expect(JSON.parse(response.body)['id']).to eq(id)
      end
    end
    context 'when record does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Record/)
      end
    end
  end
  describe 'POST /zones/:zone_id/records' do
    let(:valid_attributes) { { name: '@truezone.com', record_type: 'CNAME', record_data: 'www.truezone.com', ttl: '81' } }
    let(:a_type_and_ipv4_address_attributes) { { name: '@truezone.com', record_type: 'A', record_data: '192.168.1.255', ttl: 81 } }
    let(:a_type_but_invalid_ipv4_address_attributes) { { name: '@truzone.com' , record_type: 'A', record_data: 'www.truezone.com', ttl: 81 } }
    let(:cname_and_valid_domain_name_attributes) { { name: '@truezone', record_type: 'CNAME', record_data: 'www.truezone.com', ttl: 81 } }
    let(:cname_but_invalid_domain_name_attributes) { { name: '@truezone', record_type: 'CNAME', record_data: '198.23.4.1', ttl: 81 } }

    context 'when the record attributes are valid' do
      before { post "/zones/#{zone_id}/records", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/zones/#{zone_id}/records", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
    
    context 'when record type is A and the record data is an IPv4 address' do
      before { post "/zones/#{zone_id}/records", params: a_type_and_ipv4_address_attributes }

      it 'returns success status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    context 'when record type is A but record data is not an IPv4 address' do
      before { post "/zones/#{zone_id}/records", params: a_type_but_invalid_ipv4_address_attributes }

      it 'returns error code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: record_data must be a valid IPv4 address when record_type is A/)
      end
    end
    context 'when record type is CNAME and record_data is a valid domain name' do
      before { post "/zones/#{zone_id}/records", params: cname_and_valid_domain_name_attributes }

      it 'returns success code 201' do
        expect(response).to have_http_status(201)
      end
    end
    context 'when record_type is CNAME but record_data is not a valid domain name'
      before { post "/zones/#{zone_id}/records", params: cname_but_invalid_domain_name_attributes }

      it 'returns error code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a failure message' do
        expect(response.body).to match(/record_data must be a valid domain name when record_type is CNAME/)
      end
    end

  describe 'PUT /zones/:zone_id/records/:id' do
    let(:valid_attributes) { { name: '@updatedtruezone.com' } }

    before { put "/zones/#{zone_id}/records/#{id}", params: valid_attributes }

    context 'when record exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the record' do
        updated_record = Record.find(id)
        expect(updated_record.name).to match('@updatedtruezone.com')
      end
    end
    context 'when record does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Record/)
      end
    end
  end
  describe 'DELETE /zones/:id' do
    before { delete "/zones/#{zone_id}/records/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
