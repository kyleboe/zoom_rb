# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::SipAudio do
  let(:zc) { zoom_client }
  let(:args) { { account_id: '1' } }

  describe '#sip_trunks_internal_callout_countries_add action' do
    before :each do
      stub_request(
        :post,
        zoom_url("/accounts/#{args[:account_id]}/sip_trunk/callout_countries")
      ).to_return(body: json_response('sip_audio', 'sip_trunks_internal_callout_countries_add'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a hash' do
      expect(zc.sip_trunks_internal_callout_countries_add(args)).to be_kind_of(Hash)
    end

    it 'raises an error when missing a required param' do
      expect { zc.sip_trunks_internal_callout_countries_add }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
    end
  end
end