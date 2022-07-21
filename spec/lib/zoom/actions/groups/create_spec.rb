# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Groups do
  let(:zc) { zoom_client }
  let(:args) { { name: 'Zoom Group Name' } }
  let(:response) { zc.group_create(args) }

  describe '#group_create action' do
    context 'with 201 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/groups")
        ).to_return(
          status: 201,
          body: json_response('groups','create'),
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'returns a hash' do
        expect(response).to be_kind_of(Hash)
      end

      it 'returns the set params' do
        expect(response['name']).to eq(args[:name])
      end

      it "returns 'start_url' and 'join_url'" do
        expect(response['name']).to_not be_nil
      end
    end

    context 'with 409 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/groups")
        ).to_return(status: 409,
                    body: '{ "code": 409, "message": "Group name Zoom Group Name is already in use." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Conflict)
      end
    end

    context 'with 429 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/groups")
        ).to_return(status: 429,
                    body: '{ "code": 429, "message": "You have exceeded the daily rate limit (1) of Create a Group API request for this account. This limit resets at GMT 00:00:00." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::TooManyRequests)
      end
    end

    context 'with 300 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/groups")
        ).to_return(status: 300,
                    body: '{ "code": 300, "message": "Missing field: name." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end

    context 'with 404 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/groups")
        ).to_return(
          status: 404,
          body: json_response('error', 'group_not_exist'),
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end
  end
end