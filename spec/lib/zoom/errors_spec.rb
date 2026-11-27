# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zoom::Error do
  let(:rescue?) { false }

  subject do
    begin
      raise Zoom::ParameterMissing, "msg"
    rescue Zoom::Error => error
      if rescue?
        true
      else
        raise error
      end
    end
  end

  it 'raises specific errors' do
    expect { subject }.to raise_error(Zoom::ParameterMissing, "msg")
  end

  context 'with errors rescued' do
    let(:rescue?) { true }

    it 'descends from Zoom::Error' do
      expect(subject).to be true
    end
  end

  describe '#headers' do
    it 'is empty when no headers are given' do
      error = Zoom::BadRequest.new('msg', 300, [{ 'field' => 'topic' }])

      expect(error.message).to eq('msg')
      expect(error.code).to eq(300)
      expect(error.errors).to eq([{ 'field' => 'topic' }])
      expect(error.headers).to eq({})
      expect(Zoom::ParameterMissing.new('msg').headers).to eq({})
    end

    it 'returns the headers given as the fourth argument' do
      headers = { 'retry-after' => '2024-08-07T00:00:00Z' }
      error = Zoom::TooManyRequests.new('msg', 429, nil, headers)

      expect(error.headers).to eq(headers)
    end
  end
end
