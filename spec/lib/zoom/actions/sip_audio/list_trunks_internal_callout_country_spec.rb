# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::SipAudio do
  let(:zc) { zoom_client }
  let(:args) { { account_id: '1' } }

  describe '#sip_trunks_internal_callout_country_list action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/sip_trunk/callout_countries")
        ).to_return(body: json_response('sip_audio', 'sip_trunks_internal_callout_country_list'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires account_id param" do
        expect {
          zc.sip_trunks_internal_callout_country_list(filter_key(args, :account_id))
        }.to raise_error(Zoom::ParameterMissing, /[:account_id]/)
      end

      it 'returns a hash' do
        expect(zc.sip_trunks_internal_callout_country_list(args)).to be_kind_of(Hash)
      end

      it "returns 'internal_callout_countries' count" do
        expect(zc.sip_trunks_internal_callout_country_list(args)['callout_countries'].count).to eq(2)
      end

      it "returns 'internal_callout_country' Array" do
        expect(zc.sip_trunks_internal_callout_country_list(args)['callout_countries']).to be_kind_of(Array)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/sip_trunk/callout_countries")
        ).to_return(status: 404,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.sip_trunks_internal_callout_country_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end