# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { user_id: 'ufR9342pRyf8ePFN92dttQ' } }

  describe '#user_permissions action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:user_id]}/permissions")
        ).to_return(status: 200,
                    body: json_response('user', 'permissions'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires user_id param' do
        expect { zc.user_permissions(filter_key(args, :user_id)) }.to raise_error(Zoom::ParameterMissing, '[:user_id]')
      end

      it 'returns a hash' do
        expect(zc.user_permissions(args)).to be_kind_of(Hash)
      end

      it 'returns same params' do
        res = zc.user_permissions(args)

        expect(res['permissions']).to be_an(Array)
        expect(res['permissions']).to all(be_a(String))
        expect(res['permissions'].size).to equal(61)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:user_id]}/permissions")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.user_permissions(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
