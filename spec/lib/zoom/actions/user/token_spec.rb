# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { id: 'ufR9342pRyf8ePFN92dttQ' } }

  describe '#user_token action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:id]}/token")
        ).to_return(status: 200,
                    body: json_response('user', 'token'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires id param' do
        expect { zc.user_token(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, '[:id]')
      end

      it 'returns a hash' do
        expect(zc.user_token(args)).to be_kind_of(Hash)
      end

      it 'returns same params' do
        res = zc.user_token(args)

        expect(res['token']).to eql('string')
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:id]}/token")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.user_token(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
