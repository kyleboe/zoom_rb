# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Dashboard do

  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 't13b6hjVQXybvGKyeHC96w==', type: 1 } }
  let(:response) { zc.dashboard_meeting_participants(args) }

  describe '#dashboard_meeting_participants action' do
    context 'with 200 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/metrics/meetings/#{args[:meeting_id]}/participants")
        ).to_return(status: 200,
                    body: json_response('dashboard','meeting', 'participants'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'meeting_id' argument" do
        expect { zc.dashboard_meeting_participants(filter_key(args, :meeting_id)) }.to raise_error(Zoom::ParameterMissing)
      end

      it 'returns a hash' do
        expect(response).to be_kind_of(Hash)
      end

      it "returns 'next_page_token'" do
        expect(response['next_page_token']).to be_kind_of(String)
      end

      it "returns 'total_records'" do
        expect(response['total_records']).to eq(2)
      end

      it "returns 'participants' Array" do
        expect(response['participants']).to be_kind_of(Array)
      end
    end

    context 'with 300 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/metrics/meetings/#{args[:meeting_id]}/participants")
        ).to_return(status: 300,
                    body: '{ "code": 1001, "message": "Can not access webinar info. {meetingId} or the next page token is either invalid or expired." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end

    context 'with 404 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/metrics/meetings/#{args[:meeting_id]}/participants")
        ).to_return(status: 404,
                    body: '{ "code": 3001, "message": "Meeting ID is invalid or not ended yet." }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end
  end

end
