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
      response = { 'code' => 124, 'message' => 'Invalid access token.' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::AuthenticationError)
    end

    it 'raises Zoom::Error if error is present and code >= 300' do
      response = { 'code' => 400, 'message' => 'lol error' }
      expect { Utils.raise_if_error!(response) }.to raise_error(Zoom::Error)
    end

    it 'does not raise Zoom::Error if error is not present' do
      response = {}
      expect { Utils.raise_if_error!(response) }.to_not raise_error
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
