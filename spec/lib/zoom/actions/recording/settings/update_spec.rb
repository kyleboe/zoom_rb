# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 91538056781, on_demand: false } }

  describe '#meeting_recordings_settings_update action' do
    context 'with 204 response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/meetings/#{args[:meeting_id]}/recordings/settings")
        ).to_return(
          status: 204,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it "requires a 'meeting_id' argument" do
        expect {
          zc.meeting_recording_settings_update(filter_key(args, :meeting_id))
        }.to raise_error(Zoom::ParameterMissing, [:meeting_id].to_s)
      end

      it 'returns a status code' do
        expect(zc.meeting_recording_settings_update(args)).to eq 204
      end
    end
  end
end
