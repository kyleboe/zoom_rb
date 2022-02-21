# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::SipAudio do
  let(:zc) { zoom_client }
  let(:args) { { account_id: '1' } }

  describe '#sip_trunks_numbers_assign action' do
    before :each do
      stub_request(
        :post,
        zoom_url("/accounts/#{args[:account_id]}/sip_trunk/numbers")
      ).to_return(body: json_response('sip_audio', 'sip_trunks_numbers_assign'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a hash' do
      expect(zc.sip_trunks_numbers_assign(args)).to be_kind_of(Hash)
    end

    it "returns 'phone_numbers' Array" do
      expect(zc.sip_trunks_numbers_assign(args)['phone_numbers']).to be_kind_of(Array)
    end

    it 'raises an error when missing a required param' do
      expect { zc.sip_trunks_numbers_assign }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
    end
  end
end