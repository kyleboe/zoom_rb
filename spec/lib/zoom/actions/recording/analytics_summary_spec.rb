# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 91538056781 } }

  describe '#meeting_recording_analytics_summary action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{args[:meeting_id]}/recordings/analytics_summary")
      ).to_return(
        status: 200,
        body: json_response('recording', 'analytics_summary'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "requires a 'meeting_id' argument" do
      expect {
        zc.meeting_recording_analytics_summary(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(zc.meeting_recording_analytics_summary(args)).to be_kind_of(Hash)
    end

    it "returns 'from'" do
      expect(zc.meeting_recording_analytics_summary(args)['from']).to eq('2023-01-01')
    end

    it "returns 'to'" do
      expect(zc.meeting_recording_analytics_summary(args)['to']).to eq('2023-01-02')
    end

    it "returns 'analytics_summary' Array" do
      expect(zc.meeting_recording_analytics_summary(args)['analytics_summary']).to be_kind_of(Array)
    end

  end
end
