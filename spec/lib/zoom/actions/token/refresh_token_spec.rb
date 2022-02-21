# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Token do
  let(:zc) { oauth_client }
  let(:args) { { grant_type: 'refresh_token', refresh_token: 'xxx' } }

  describe '#refresh_tokens action' do
    let(:path) { '/oauth/token' }

    let(:params) do
      {
        base_uri: 'https://zoom.us/',
        body: URI.encode_www_form(args.to_a),
        headers: {
          'Accept'=>'application/json',
          'Authorization'=>'Basic eHh4Onh4eA==',
          'Content-Type'=>'application/x-www-form-urlencoded'
        }
      }
    end

    before :each do
      Zoom.configure do |config|
        config.api_key = 'xxx'
        config.api_secret = 'xxx'
      end

      allow(Zoom::Utils).to receive(:parse_response).and_return(code: 200)
      allow(Zoom::Client::OAuth).to(
        receive(:post).with(path, params)
          .and_return(body: json_response('token', 'access_token'),
                        headers: { 'Content-Type' => 'application/json' })
      )
    end

    it "raises an error when args missing" do
      expect { zc.refresh_tokens }.to raise_error(Zoom::ParameterMissing, [:grant_type, :refresh_token].to_s)
    end

    it 'returns a hash' do
      expect(zc.refresh_tokens(args)).to be_kind_of(Hash)
    end

    it 'passes args in the body and sends x-www-form-urlencoded header' do
      zc.refresh_tokens(args)
      expect(Zoom::Client::OAuth).to have_received(:post).with(path, params)
    end
  end
end
