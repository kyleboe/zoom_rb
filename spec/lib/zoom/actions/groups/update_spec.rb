# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Groups do
  let(:zc) { zoom_client }
  let(:args) { { group_id: '555' } }

  describe '#group_update' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/groups/#{args[:group_id]}")
        ).to_return(status: 204,
                    body: json_response('groups', 'update'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires id param' do
        expect { zc.group_update(filter_key(args, :group_id)) }.to raise_error(Zoom::ParameterMissing, [:group_id].to_s)
      end

      it 'returns the http status code as a number' do
        expect(zc.group_update(args)).to eql(204)
      end
    end

    context 'with a 404 response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/groups/#{args[:group_id]}")
        ).to_return(status: 404,
                    body: '{ "code": 404, "message": "Group name Zoom Group Name is already in use." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::NotFound' do
        expect { zc.group_update(args) }.to raise_error(Zoom::NotFound)
      end
    end

    context 'with 409 response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/groups/#{args[:group_id]}")
        ).to_return(status: 409,
                    body: '{ "code": 409, "message": "Group name Zoom Group Name is already in use." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Conflict' do
        expect { zc.group_update(args) }.to raise_error(Zoom::Conflict)
      end
    end
  end
end
