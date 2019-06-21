# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do

  before :all do
    @zc = oauth_client
    @args = { user_id: 'kEFomHcIRgqxZT8D086O6A' }
  end

  describe '#cloud_recording_list action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/users/#{@args[:user_id]}/recordings")
      ).to_return(body: json_response('cloud_recording/cloud_recording_list'), headers: { 'Content-Type' => 'application/json' })
    end

    it "requires a 'user_id' argument" do
      expect { @zc.cloud_recording_list }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a hash' do
      expect(@zc.cloud_recording_list(@args)).to be_kind_of(Hash)
    end

    it "returns 'total_records'" do
      expect(@zc.cloud_recording_list(@args)['total_records']).to eq(1)
    end

    it "returns 'meetings' Array" do
      expect(@zc.cloud_recording_list(@args)['meetings']).to be_kind_of(Array)
      expect(@zc.cloud_recording_list(@args)['meetings'].length).to eq(1)
    end
    it "returns 'recording_files' Array" do
      recording_files = @zc.cloud_recording_list(@args)['meetings'][0]['recording_files']
      expect(recording_files).to be_kind_of(Array)
      expect(recording_files.length).to eq(3)
    end
  end

  describe '#cloud_recording_list! action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/users/#{@args[:user_id]}/recordings")
      ).to_return(
        status: 400,
        body: json_response('error/invalid_access_token'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'raises Zoom::Error exception' do
      expect {
        @zc.cloud_recording_list(@args)
      }.to raise_error(Zoom::Error)
    end
  end
end
