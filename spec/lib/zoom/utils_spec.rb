# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Utils do

  before(:all) do
    class Utils < Zoom::Utils; end
  end

  describe '#argument_error' do
    it 'raises ArgumentError' do
      expect(Utils.argument_error('foo')).to be_instance_of(ArgumentError)
    end
  end

  describe '#raise_error' do
    it 'raises Zoom::BadRequest if error is present and http code = 400' do
      response = { 'code' => 123, 'message' => 'Bad request.' }
      expect { Utils.raise_error(response, 400) }.to raise_error(Zoom::BadRequest)
    end

    it 'raises Zoom::Unauthorized if error is present and http code = 401' do
      response = { 'code' => 123, 'message' => 'Unauthorized.' }
      expect { Utils.raise_error(response, 401) }.to raise_error(Zoom::Unauthorized)
    end

    it 'raises Zoom::Forbidden if error is present and http code = 403' do
      response = { 'code' => 123, 'message' => 'Forbidden.' }
      expect { Utils.raise_error(response, 403) }.to raise_error(Zoom::Forbidden)
    end

    it 'raises Zoom::NotFound if error is present and http code = 404' do
      response = { 'code' => 123, 'message' => 'NotFound.' }
      expect { Utils.raise_error(response, 404) }.to raise_error(Zoom::NotFound)
    end

    it 'raises Zoom::Conflict if error is present and http code = 409' do
      response = { 'code' => 123, 'message' => 'Conflict.' }
      expect { Utils.raise_error(response, 409) }.to raise_error(Zoom::Conflict)
    end

    it 'raises Zoom::TooManyRequests if error is present and http code = 429' do
      response = { 'code' => 123, 'message' => 'Too many requests.' }
      expect { Utils.raise_error(response, 429) }.to raise_error(Zoom::TooManyRequests)
    end

    it 'raises Zoom::InternalServerError if error is present and http code = 500' do
      response = { 'code' => 123, 'message' => 'Internal server error.' }
      expect { Utils.raise_error(response, 500) }.to raise_error(Zoom::InternalServerError)
    end

    it 'raises Zoom::Error if http code is not in [400, 401, 403, 404, 429, 500]' do
      response = { 'code' => 180, 'message' => 'lol error' }
      expect { Utils.raise_error(response, 101) }.to raise_error(Zoom::Error)
    end

    it 'raises Zoom::Error if http code is not in [400, 401, 403, 404, 429, 500]' do
      response = { 'code' => 180, 'message' => 'lol error' }
      expect { Utils.raise_error(response, 101) }.to raise_error(Zoom::Error)
    end

    it 'extracts error attributes from response' do
      response = json_response('error', 'validation')
      expect { Utils.raise_error(response, 400) }.to raise_error { |error|
        expect(error.message).to eq(response['message'])
        expect(error.code).to eq(response['code'])
        expect(error.errors).to eq(response['errors'])
      }
    end

    it 'passes response headers to the error' do
      response = { 'code' => 429, 'message' => 'Too many requests.' }
      headers = { 'x-ratelimit-type' => 'QPS' }
      expect { Utils.raise_error(response, 429, headers) }.to raise_error { |error|
        expect(error.headers).to eq(headers)
      }
    end

    it 'leaves error headers empty if none are given' do
      response = { 'code' => 429, 'message' => 'Too many requests.' }
      expect { Utils.raise_error(response, 429) }.to raise_error { |error|
        expect(error.headers).to eq({})
      }
    end
  end

  describe '#parse_response' do
    it 'returns response if http response is successful' do
      parsed_response = json_response('account', 'get')
      response = double('Response', success?: true, parsed_response: parsed_response, code: 200)
      expect(Utils.parse_response(response)).to eq(parsed_response)
    end

    it 'returns http status code if http response is successful and parsed response is nil' do
      response = double('Response', success?: true, parsed_response: nil, code: 200)
      expect(Utils.parse_response(response)).to eq(200)
    end

    it 'does not raise Zoom::Error if response is not a Hash' do
      response = double('Response', success?: true, parsed_response: 'xxx', code: 200)
      expect { Utils.parse_response(response) }.to_not raise_error
    end
  end

  describe '#extract_options!' do
    it 'converts array to hash options' do
      args = [{ foo: 'foo' }, { bar: 'bar' }, { zemba: 'zemba' }]
      expect(Utils.extract_options!(args)).to be_kind_of(Hash)
    end
  end

  describe '#process_datetime_params' do
    it 'converts the Time objects to formatted strings' do
      args = {
        foo: 'foo',
        bar: Time.utc(2000, 'jan', 1, 20, 15, 1)
      }
      expect(
        Utils.process_datetime_params!(args)
      ).to eq({ foo: 'foo',
                bar: '2000-01-01T20:15:01Z' })
    end
  end
end
