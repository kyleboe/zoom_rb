# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Groups do
  let(:zc) { zoom_client }
  let(:args) { { group_id: 2 } }
  let(:wrong_args) { { group_id: 999999 } }

  describe '#groups_get action' do
    context 'with valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/groups/#{args['group_id']}")
        ).to_return(body: json_response('groups', 'get'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a hash' do
        expect(zc.groups_get(args)).to be_kind_of(Hash)
      end

      it "return 'name' parameter" do
        expect(zc.groups_get(args)['name']).not_to be_nil
      end
    end

    context 'with a 404 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/groups/#{wrong_args['group_id']}")
        ).to_return(status: 404,
                    body: json_response('error', 'group_does_not_exist'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception with text' do
        expect { zc.groups_get(wrong_args) }.to raise_error(Zoom::Error, {
          base: 'A group with this 999999 does not exist.'
        }.to_s)
      end
    end

    context 'with a 400 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/groups/#{wrong_args['group_id']}")
        ).to_return(status: 400,
                    body: json_response('error', 'group_not_belong_to_account'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception with text' do
        expect { zc.groups_get(wrong_args) }.to raise_error(Zoom::Error, {
          base: 'Group does not belong to your account.'
        }.to_s)
      end
    end
  end
end
