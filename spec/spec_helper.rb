# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  if ENV["CI"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end

  add_filter %w[version.rb spec]
end

require "rubygems"
require "bundler/setup"
require "zoom_rb"
require "webmock/rspec"

RSpec.configure do |config|
  # some (optional) config here
end

def fixture(*path, filename)
  File.join("spec", "fixtures", path, filename)
end

def json_response(*path, endpoint)
  open(fixture(path, endpoint + ".json")).read
end

def request_headers
  {
    "Accept" => "application/json",
    "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
    "Content-Type" => "application/json",
    "Authorization" => "Bearer",
    "User-Agent" => "Ruby"
  }
end

def zoom_url(url)
  /https:\/\/api.zoom.us\/v2#{url}.*/
end

# OAuth endpoints have a different base_uri
def zoom_auth_url(url)
  /https:\/\/zoom.us\/#{url}.*/
end

def oauth_client
  Zoom::Client::OAuth.new(auth_token: "xxx", auth_code: "xxx", redirect_uri: "xxx", timeout: 15)
end

def server_to_server_oauth_client
  Zoom.new
end

def zoom_client
  server_to_server_oauth_client
end

def filter_key(hash, key)
  copy = hash.dup
  copy.delete(key)
  copy
end
