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

  describe '#raise_if_error!' do
    it 'raises Zoom::AuthenticationError if error is present and code = 124' do
      response = { 'code' => 124, 'message' => 'Authentication error.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::AuthenticationError)
    end

    it 'raises Zoom::BadRequest if error is present and code = 400' do
      response = { 'code' => 400, 'message' => 'Bas request.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::BadRequest)
    end

    it 'raises Zoom::Unauthorized if error is present and code = 401' do
      response = { 'code' => 401, 'message' => 'Unauthorized.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::Unauthorized)
    end

    it 'raises Zoom::Forbidden if error is present and code = 403' do
      response = { 'code' => 403, 'message' => 'Forbidden.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::Forbidden)
    end

    it 'raises Zoom::NotFound if error is present and code = 404' do
      response = { 'code' => 404, 'message' => 'NotFound.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::NotFound)
    end

    it 'raises Zoom::Conflict if error is present and code = 409' do
      response = { 'code' => 409, 'message' => 'Conflict.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::Conflict)
    end

    it 'raises Zoom::TooManyRequests if error is present and code = 429' do
      response = { 'code' => 429, 'message' => 'Too many requests.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::TooManyRequests)
    end

    it 'raises Zoom::InternalServerError if error is present and code = 500' do
      response = { 'code' => 500, 'message' => 'Internal server error.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::InternalServerError)
    end

    it 'does not raise Zoom::Error if error is not present' do
      response = {}
      expect { Utils.raise_if_error!(response) }.to_not raise_error
    end

    it 'does not raise Zoom::Error if response is not a Hash' do
      response = 'xxx'
      expect { Utils.raise_if_error!(response) }.to_not raise_error
    end

    it 'raises Zoom::Error if http code is not in [124, 400, 401, 403, 404, 429, 500]' do
      response = { 'code' => 180, 'message' => 'lol error' }
      expect { Utils.raise_if_error!(response, 400) }.to raise_error(Zoom::Error)
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
