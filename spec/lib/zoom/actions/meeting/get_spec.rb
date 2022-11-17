# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 91538056781 } }

  describe '#meeting_get action' do
    before :each do
      stub_request(
        :get,
        zoom_url("/meetings/#{args[:meeting_id]}")
      ).to_return(
        status: 200,
        body: json_response('meeting','get'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "requires a 'meeting' argument" do
      expect {
        zc.meeting_get(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing, [:meeting_id].to_s)
    end

    it 'returns a hash' do
      expect(zc.meeting_get(args)).to be_kind_of(Hash)
    end

    it 'returns id and attributes' do
      res = zc.meeting_get(args)

      expect(res['id']).to eq(args[:meeting_id])
      expect(res['topic']).to eq('Zoom Meeting Topic')
      expect(res['start_time']).to eq('2020-05-05T21:00:00Z')
      expect(res['join_url']).to eq('https://company.zoom.us/j/91538056781')
      expect(res['start_url']).to eq('https://company.zoom.us/s/91538056781?zak=eyJ6bV...')
    end
  end

  describe '#meeting_get! action' do
    it 'raises NoMethodError exception' do
      expect {
        zc.meeting_get!(args)
      }.to raise_error(NoMethodError)
    end
  end

  describe '#past_meeting_instances' do
    before :each do
      stub_request(
        :get,
        zoom_url("/past_meetings/#{args[:meeting_id]}/instances")
      ).to_return(
        status: 200,
        body: json_response('meeting','instances'){},
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'returns meeting instances' do
      res = zc.past_meeting_instances(args)

      expect(res['meetings'][0]['start_time']).to eq('2022-03-26T05:37:59Z')
      expect(res['meetings'][0]['uuid']).to eq('Vg8IdgluR5WDeWIkpJlElQ==')
    end
  end
end
