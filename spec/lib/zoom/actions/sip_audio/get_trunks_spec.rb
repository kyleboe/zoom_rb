# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::SipAudio do
  let(:zc) { zoom_client }
  let(:args) { { account_id: '1' } }

  describe '#sip_trunks_get action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/sip_trunk/trunks")
          ).to_return(status: 200,
                      body: json_response('sip_audio', 'sip_trunks_get'),
                      headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires id param' do
        expect { zc.sip_trunks_get }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end

      it 'returns a hash' do
        expect(zc.sip_trunks_get(args)).to be_kind_of(Hash)
      end

      it 'returns same params' do
        res = zc.sip_trunks_get(args)

        expect(res.keys).to match_array(%w[sip_trunks total_records])
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/sip_trunk/trunks")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.sip_trunks_get(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
