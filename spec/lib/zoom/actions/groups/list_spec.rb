# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Groups do
  let(:zc) { zoom_client }

  describe '#groups_list action' do
    context 'with valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/groups')
        ).to_return(body: json_response('groups', 'list'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a hash' do
        expect(zc.groups_list).to be_kind_of(Hash)
      end

      it "returns 'total_records'" do
        expect(zc.groups_list['total_records']).to eq(2)
      end

      it "returns 'groups' Array" do
        expect(zc.groups_list['groups']).to be_kind_of(Array)
      end
    end

    context 'with a 404 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/groups")
        ).to_return(status: 404,
                    body: json_response('error', 'group_does_not_exist'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception with text' do
        expect { zc.groups_list }.to raise_error(Zoom::Error, {
          base: 'A group with this 999999 does not exist.'
        }.to_s)
      end
    end
  end
end
