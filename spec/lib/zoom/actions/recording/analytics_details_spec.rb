# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 91538056781 } }

  describe '#meeting_recording_analytics_details action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{args[:meeting_id]}/recordings/analytics_details")
      ).to_return(
        status: 200,
        body: json_response('recording', 'analytics_details'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "requires a 'meeting_id' argument" do
      expect {
        zc.meeting_recording_analytics_details(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(zc.meeting_recording_analytics_details(args)).to be_kind_of(Hash)
    end

    it "returns 'from'" do
      expect(zc.meeting_recording_analytics_details(args)['from']).to eq('2023-01-01')
    end

    it "returns 'to'" do
      expect(zc.meeting_recording_analytics_details(args)['to']).to eq('2023-01-02')
    end

    it "returns 'next_page_token'" do
      expect(zc.meeting_recording_analytics_details(args)['next_page_token']).to eq('')
    end

    it "returns 'page_size'" do
      expect(zc.meeting_recording_analytics_details(args)['page_size']).to eq(30)
    end

    it "returns 'total_records'" do
      expect(zc.meeting_recording_analytics_details(args)['total_records']).to eq(1)
    end

    it "returns 'analytics_details' Array" do
      expect(zc.meeting_recording_analytics_details(args)['analytics_details']).to be_kind_of(Array)
    end

  end
end
