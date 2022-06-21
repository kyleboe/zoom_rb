# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler/setup'
require 'zoom_rb'
require 'webmock/rspec'

RSpec.configure do |config|
  # some (optional) config here
end

def fixture(*path, filename)
  File.join('spec', 'fixtures', path, filename)
end

def json_response(*path, endpoint)
  open(fixture(path, endpoint + '.json')).read
end

def request_headers
  {
    'Accept' => 'application/json',
    'Content-Type' => 'application/json',
    'Authorization' => /Bearer .+/
  }
end

def zoom_url(url)
  /https:\/\/api.zoom.us\/v2#{url}.*/
end

#OAuth endpoints have a different base_uri
def zoom_auth_url(url)
  /https:\/\/zoom.us\/#{url}.*/
end

def jwt_client
  Zoom.new
end

def oauth_client
  Zoom::Client::OAuth.new(auth_token: 'xxx', auth_code: 'xxx', redirect_uri: 'xxx', timeout: 15)
end

def server_to_server_oauth_client
  Zoom::Client::ServerToServerOAuth.new(account_id: 'xxx')
end

def zoom_client
  jwt_client
end

def filter_key(hash, key)
  copy = hash.dup
  copy.delete(key)
  copy
end
