# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Dashboard do
  let(:zc) { zoom_client }
  let(:args) { { from: '2013-04-05T15:50:47Z', to: '2013-04-09T19:00:00Z' } }
  let(:response) { zc.dashboard_crc(args) }

  describe '#dashboard_crc get' do
    before :each do
      stub_request(
        :get,
        zoom_url('/metrics/crc')
      ).to_return(status: 200,
                  body: json_response('dashboard','crc'),
                  headers: { 'Content-Type' => 'application/json' })
    end

    it "requires a 'from' argument" do
      expect { zc.dashboard_crc(filter_key(args, :from)) }.to raise_error(Zoom::ParameterMissing)
    end

    it "requires a 'to' argument" do
      expect { zc.dashboard_crc(filter_key(args, :to)) }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end
  end

end
