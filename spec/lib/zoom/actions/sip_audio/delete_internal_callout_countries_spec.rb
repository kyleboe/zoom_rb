# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::SipAudio do
  let(:zc) { zoom_client }
  let(:args) { { account_id: 1, country_id: 1 } }

  describe '#sip_trunks_internal_callout_country_delete action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :delete,
          zoom_url("/accounts/#{args[:account_id]}/sip_trunk/callout_countries/#{args[:country_id]}")
        ).to_return(status: 204,
                    body: nil,
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires the account_id params and country_id params' do
        expect { zc.sip_trunks_internal_callout_country_delete }.to raise_error(Zoom::ParameterMissing, [:account_id, :country_id].to_s )
      end

      it 'returns the http status code as a number' do
        expect(zc.sip_trunks_internal_callout_country_delete(args)).to eql(204)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :delete,
          zoom_url("/accounts/#{args[:account_id]}/sip_trunk/callout_countries/#{args[:country_id]}")
        ).to_return(status: 400,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.sip_trunks_internal_callout_country_delete(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
