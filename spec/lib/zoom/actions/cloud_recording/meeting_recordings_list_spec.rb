# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do

  before :all do
    @zc = oauth_client
    @args = { meeting_id: 'TvycqysNuLLFzA==' }
  end

  describe '#meeting_recordings_list action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{@args[:meeting_id]}/recordings")
      ).to_return(body: json_response('cloud_recording/meeting_recordings_list'), headers: { 'Content-Type' => 'application/json' })
    end

    let(:response) { @zc.meeting_recordings_list(@args) }

    it "requires a 'meeting_id' argument" do
      expect { @zc.meeting_recordings_list }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end

    it "returns 'uuid'" do
      expect(response['uuid']).to eq('TvycqysNuLLFzA==')
    end

    it "returns 'recording_count'" do
      expect(response['recording_count']).to eq(2)
    end

    it "returns 'recording_files' Array" do
      expect(response['recording_files']).to be_kind_of(Array)
      expect(response['recording_files'].length).to eq(2)
    end
  end

  describe '#meeting_recordings_list! action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{@args[:meeting_id]}/recordings")
      ).to_return(
        status: 400,
        body: json_response('error/invalid_access_token'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'raises Zoom::Error exception' do
      expect {
        @zc.meeting_recordings_list(@args)
      }.to raise_error(Zoom::Error)
    end
  end
end
