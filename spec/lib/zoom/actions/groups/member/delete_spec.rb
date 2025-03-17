# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Groups do
  let(:zc) { zoom_client }
  let(:args) { { group_id: '123', member_id: '456' } }

  describe '#group_member_delete action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :delete,
          zoom_url("/groups/#{args[:group_id]}/members/#{args[:member_id]}")
        ).to_return(status: 204, body: nil)
      end

      it 'requires group_id param' do
        expect { zc.group_member_delete(filter_key(args, :group_id)) }.to raise_error(Zoom::ParameterMissing, [:group_id].to_s)
      end

      it 'requires member_id param' do
        expect { zc.group_member_delete(filter_key(args, :member_id)) }.to raise_error(Zoom::ParameterMissing, [:member_id].to_s)
      end

      it 'returns the http status code as a number' do
        expect(zc.group_member_delete(args)).to eq(204)
      end
    end

    context 'with a 4xx response' do
      context '404 not found' do
        before :each do
          stub_request(
            :delete,
            zoom_url("/groups/#{args[:group_id]}/members/#{args[:member_id]}")
          ).to_return(status: 404,
                      body: json_response('error', 'group_not_exist'),
                      headers: { 'Content-Type' => 'application/json' })
        end

        it 'raises Zoom::Error exception' do
          expect { zc.group_member_delete(args) }.to raise_error(Zoom::Error)
        end
      end

      context 'group does not belong to account' do
        before :each do
          stub_request(
            :delete,
            zoom_url("/groups/#{args[:group_id]}/members/#{args[:member_id]}")
          ).to_return(status: 400,
                      body: json_response('error', 'group_not_belong_to_account'),
                      headers: { 'Content-Type' => 'application/json' })
        end

        it 'raises Zoom::Error exception' do
          expect { zc.group_member_delete(args) }.to raise_error(Zoom::Error)
        end
      end

      context 'member does not exist' do
        before :each do
          stub_request(
            :delete,
            zoom_url("/groups/#{args[:group_id]}/members/#{args[:member_id]}")
          ).to_return(status: 404,
                      body: { "code": 4131, "message": "Group member does not exist." }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
        end

        it 'raises Zoom::Error exception' do
          expect { zc.group_member_delete(args) }.to raise_error(Zoom::Error)
        end
      end
    end
  end
end