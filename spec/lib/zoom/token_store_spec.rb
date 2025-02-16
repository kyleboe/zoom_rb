# frozen_string_literal: true

require 'spec_helper'

describe Zoom::TokenStore do
  subject { described_class.build(config) }

  let(:access_token) { 'xxx' }
  let(:refresh_token) { 'xxx' }
  let(:expires_in) { 3599 }
  let(:expires_at) { (Time.now + expires_in).to_i }

  shared_examples 'sets and gets token values' do
    it do
      subject.access_token = access_token
      subject.refresh_token = refresh_token
      subject.expires_in = expires_in
      subject.expires_at = expires_at

      expect(subject.access_token).to eq(access_token)
      expect(subject.refresh_token).to eq(refresh_token)
      expect(subject.expires_in).to eq(expires_in)
      expect(subject.expires_at).to eq(expires_at)
    end
  end

  describe 'Memory store' do
    let(:config) { :memory }

    it_behaves_like 'sets and gets token values'
  end

  describe 'Redis store' do
    let(:config) do
      [:redis, {
        host: '127.0.0.1',
        port: '6379',
        db: '0'
      }]
    end

    before do
      allow(subject).to receive(:storage).and_return(FakeRedisStorage.new)
    end

    it_behaves_like 'sets and gets token values'
  end

  describe 'Unknown store' do
    let(:config) { :unknown }

    it 'raises an error if there is no token' do
      expect { subject }.to raise_error(NameError)
    end
  end
end
