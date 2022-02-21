# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::SipAudio do
  let(:zc) { zoom_client }

  describe '#sip_trunks_numbers_list action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/sip_trunk/numbers")
        ).to_return(body: json_response('sip_audio', 'sip_trunks_numbers_list'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a hash' do
        expect(zc.sip_trunks_numbers_list).to be_kind_of(Hash)
      end

      it "returns 'numbers' count" do
        expect(zc.sip_trunks_numbers_list['phone_numbers'].count).to eq(1)
      end

      it "returns 'numbers' Array" do
        expect(zc.sip_trunks_numbers_list['phone_numbers']).to be_kind_of(Array)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/sip_trunk/numbers")
        ).to_return(status: 404,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.sip_trunks_numbers_list }.to raise_error(Zoom::Error)
      end
    end
  end
end