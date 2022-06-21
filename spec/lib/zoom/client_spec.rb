# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Client do

  describe 'default attributes' do
    it 'must include httparty methods' do
      expect(Zoom::Client).to include(HTTParty)
      expect(Zoom::Client::JWT).to include(HTTParty)
    end

    it 'must have the base url set to Zoom API endpoint' do
      expect(Zoom::Client.base_uri).to eq('https://api.zoom.us/v2')
    end

    it 'must have a default timeout set to 15 seconds' do
      Zoom.configure do |config|
        config.api_key = 'xxx'
        config.api_secret = 'xxx'
      end
      Zoom.new
      expect(Zoom::Client::JWT.default_options[:timeout]).to eq(15)
      Zoom.configuration = nil
    end

    it 'must get the timeout from the configuration' do
      Zoom.configure do |config|
        config.api_key = 'xxx'
        config.api_secret = 'xxx'
        config.timeout = 20
      end
      Zoom.new
      expect(Zoom::Client::JWT.default_options[:timeout]).to eq(20)
      Zoom.configuration = nil
    end
  end

  describe 'JWT client' do
    let(:client) {
      Zoom::Client::JWT.new(api_key: 'xxx', api_secret: 'xxx', timeout: 15)
    }
    it 'requires api_key and api_secret for a new instance' do
      expect { Zoom::Client::JWT.new(api_key: 'xxx') }.to raise_error(Zoom::ParameterMissing)
      expect { Zoom::Client::JWT.new(api_key: 'xxx', api_secret: 'xxx') }.not_to raise_error
    end

    it 'creates instance of Zoom::Client if api_key and api_secret is provided' do
      expect(client).to be_kind_of(Zoom::Client)
    end

    it 'has the bearer token in the auth header' do
      fake_token = 'NotTheRealToken'
      allow(client).to receive(:access_token) {fake_token}
      expect(client.request_headers['Authorization']).to eq("Bearer #{fake_token}")
    end

  end

  describe 'OAuth client' do
    let(:access_token) {'xxx'}
    let(:refresh_token) {'xxx'}
    let(:auth_token) {'xxx'}
    let(:client) {
      Zoom::Client::OAuth.new(access_token: access_token, timeout: 30)
    }
    it 'raises an error if there is no token' do
      expect { Zoom::Client::OAuth.new(timeout: 30) }.to raise_error(Zoom::ParameterMissing)
    end

    it 'raises an error if there is no complete auth token, auth code and redirect_uri' do
      expect { Zoom::Client::OAuth.new(auth_token: 'xxx', auth_code: 'xxx', redirect_uri: 'xxx') }.not_to raise_error
    end

    it 'requires atleast an access token' do
      expect { Zoom::Client::OAuth.new(access_token: access_token) }.not_to raise_error
    end

    it 'requires atleast a refresh token' do
      expect { Zoom::Client::OAuth.new(refresh_token: refresh_token) }.not_to raise_error
    end

    it 'creates instance of Zoom::Client if api_key and api_secret is provided' do
      expect(client).to be_kind_of(Zoom::Client)
    end

    it 'has the bearer token in the auth header' do
      expect(client.request_headers['Authorization']).to eq("Bearer #{access_token}")
    end

    describe 'set_tokens' do
      let(:zc) { oauth_client }
      let(:args) { { auth_code: 'xxx', redirect_uri: 'http://localhost:3000' } }

      before :each do
        Zoom.configure do |config|
          config.api_key = 'xxx'
          config.api_secret = 'xxx'
          config.timeout = 20
        end

        stub_request(
          :post,
          zoom_auth_url('oauth/token')
        ).to_return(body: json_response('token', 'access_token'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'sets the refresh_token, access_token, expires_in and expires_at' do
        expected_values = JSON.parse(json_response('token', 'access_token'))
        zc.auth
        expect(zc.access_token).to eq(expected_values['access_token'])
        expect(zc.refresh_token).to eq(expected_values['refresh_token'])
        expect(zc.expires_in).to eq(expected_values['expires_in'])
        expect(zc.expires_at).to eq((Time.now + expected_values['expires_in']).to_i)
      end

      it 'has the basic auth authorization header' do
        expect(zc.oauth_request_headers['Authorization']).to eq("Basic eHh4Onh4eA==")
      end
    end
  end

  describe 'ServerToServerOAuth client' do
    let(:access_token) {'xxx'}
    let(:client) do
      Zoom::Client::ServerToServerOAuth.new(access_token: access_token, timeout: 30)
    end

    it 'raises an error if there is no arguments' do
      expect { Zoom::Client::ServerToServerOAuth.new(timeout: 30) }.to raise_error(Zoom::ParameterMissing)
    end

    it 'requires at least an access token' do
      expect { Zoom::Client::ServerToServerOAuth.new(access_token: access_token) }.not_to raise_error
    end

    it 'requires at least an account_id' do
      expect { Zoom::Client::ServerToServerOAuth.new(access_token: access_token) }.not_to raise_error
    end

    it 'creates instance of Zoom::Client if api_key and api_secret is provided' do
      expect(client).to be_kind_of(Zoom::Client)
    end

    it 'has the bearer token in the auth header' do
      expect(client.request_headers['Authorization']).to eq("Bearer #{access_token}")
    end

    describe 'set_tokens' do
      let(:client) { Zoom::Client::ServerToServerOAuth.new(account_id: 'xxx') }

      before :each do
        Zoom.configure do |config|
          config.timeout = 20
        end

        stub_request(
          :post,
          zoom_auth_url('oauth/token')
        ).to_return(body: json_response('token', 'access_token'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'sets the access_token, expires_in and expires_at' do
        expected_values = JSON.parse(json_response('token', 'access_token'))
        client.auth
        expect(client.access_token).to eq(expected_values['access_token'])
        expect(client.expires_in).to eq(expected_values['expires_in'])
        expect(client.expires_at).to eq((Time.now + expected_values['expires_in']).to_i)
      end

      context 'when client_id and client_secret is not provided' do
        it 'has the basic auth authorization header based on api_key and api_secret' do
          expect(client.oauth_request_headers['Authorization']).to eq("Basic eHh4Onh4eA==")
        end
      end

      context 'when client_id and client_secret are provided' do
        let(:client) { Zoom::Client::ServerToServerOAuth.new(account_id: 'xxx', client_id: 'yyy', client_secret: 'yyy') }

        it 'has the basic auth authorization header based on client_id and client_secret' do
          expect(client.oauth_request_headers['Authorization']).to eq("Basic eXl5Onl5eQ==")
        end
      end
    end
  end
end
