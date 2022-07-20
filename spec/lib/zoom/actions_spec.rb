# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions do
  let(:client) { Zoom::Client::OAuth.new(access_token: 'xxx', timeout: 15) }
  let(:path) { '/:id/foo/:bar' }
  let(:path_keys) { [:id, :bar] }
  let(:params) { { id: 100, bar: 'baz' } }
  let(:oauth) { false }
  let(:parsed_path) { '/100/foo/baz' }

  describe 'self.extract_path_keys' do
    subject { described_class.extract_path_keys(path) }

    it { is_expected.to match_array(path_keys) }
  end

  describe 'self.parse_path' do
    subject { described_class.parse_path(path, path_keys, params) }

    it { is_expected.to eq(parsed_path) }
  end

  describe 'self.make_request' do
    subject do
      described_class.make_request({
        client: client, method: method, parsed_path: parsed_path,
        params: params, request_options: request_options
      })
    end

    let(:request_options) { Zoom::Actions.determine_request_options(client, oauth) }

    before :each do
      Zoom.configure do |config|
        config.api_key = 'xxx'
        config.api_secret = 'xxx'
      end
    end

    context 'when get' do
      let(:method) { :get }

      it 'calls get method on client with get request_options' do
        request_options[:query] = params
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end

    context 'when post' do
      let(:method) { :post }

      it 'calls post method on client with post request_options' do
        request_options[:body] = params.to_json
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end

    context 'when put' do
      let(:method) { :put }

      it 'calls put method on client with put request_options' do
        request_options[:body] = params.to_json
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end

    context 'when patch' do
      let(:method) { :patch }

      it 'calls patch method on client with patch request_options' do
        request_options[:body] = params.to_json
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end

    context 'when delete' do
      let(:method) { :delete }

      it 'calls delete method on client with delete request_options' do
        request_options[:query] = params
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end

    context 'when oauth' do
      let(:method) { :get }
      let(:oauth) { true }

      it 'passes oauth request options' do
        request_options[:query] = params
        expect(request_options[:headers]).to eq(client.oauth_request_headers)
        expect(request_options[:base_uri]).to eq('https://zoom.us/')
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end

    context 'when not oauth' do
      let(:method) { :get }
      let(:oauth) { false }

      it 'passes standard request options' do
        request_options[:query] = params
        expect(request_options[:headers]).to eq(client.request_headers)
        expect(request_options[:base_uri]).to be_nil
        expect(client.class).to receive(method).with(parsed_path, **request_options)
        subject
      end
    end
  end
end
