# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 91538056781 } }

  describe '#meeting_recordings_settings_get action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{args[:meeting_id]}/recordings/settings")
      ).to_return(
        status: 200,
        body: json_response('recording', 'settings', 'get'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "requires a 'meeting_id' argument" do
      expect {
        zc.meeting_recording_settings_get(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(zc.meeting_recording_settings_get(args)).to be_kind_of(Hash)
    end

    it 'returns id and attributes' do
      res = zc.meeting_recording_settings_get(args)

      expect(res['on_demand']).to eq(false)
      expect(res['password']).to eq('')
      expect(res['recording_authentication']).to eq(false)
      expect(res['share_recording']).to eq('publicly')
      expect(res['viewer_download']).to eq(false)
    end

  end
end
