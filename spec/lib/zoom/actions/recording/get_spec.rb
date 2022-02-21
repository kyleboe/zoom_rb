# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do
  let(:zc) { zoom_client }
  let(:args) { { user_id: 'kEFomHcIRgqxZT8D086O6A', meeting_id: 933560800 } }

  describe '#meeting_recording_get action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{args[:meeting_id]}/recordings")
      ).to_return(
        status: 200,
        body: json_response('recording', 'get'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "requires a 'meeting_id' argument" do
      expect {
        zc.meeting_recording_get(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(zc.meeting_recording_get(args)).to be_kind_of(Hash)
    end

    it 'returns id and attributes' do
      res = zc.meeting_recording_get(args)

      expect(res['uuid']).to eq("ucc69C82Q5mTNyCRWE29Aw==")
      expect(res['id']).to eq(args[:meeting_id])
      expect(res['host_id']).to eq('kEFomHcIRgqxZT8D086O6A')
      expect(res['account_id']).to eq('NyEqCEoYSNOr4jLMHoO2tA')
      expect(res['topic']).to eq('Meeting Topic Name')
      expect(res['start_time']).to eq('2015-04-13T01:06:04Z')
      expect(res['timezone']).to eq('UTC')
      expect(res['duration']).to eq(1)
      expect(res['total_size']).to eq(686496)
      expect(res['recording_count']).to eq(3)
    end

    it "returns 'recording_files' Array" do
      expect(zc.meeting_recording_get(args)['recording_files']).to be_kind_of(Array)
    end
  end
end
