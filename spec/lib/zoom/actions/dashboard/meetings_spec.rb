# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Dashboard do
  let(:zc) { zoom_client }
  let(:args) { { type: 1, from: '2013-04-05T15:50:47Z', to: '2013-04-09T19:00:00Z' } }
  let(:response) { zc.dashboard_meetings(args) }

  describe '#dashboard_meetings action' do
    context 'with 200 response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/metrics/meetings')
        ).to_return(status: 200,
                    body: json_response('dashboard','meetings'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'from' argument" do
        expect { zc.dashboard_meetings(filter_key(args, :from)) }.to raise_error(Zoom::ParameterMissing)
      end

      it "requires a 'to' argument" do
        expect { zc.dashboard_meetings(filter_key(args, :to)) }.to raise_error(Zoom::ParameterMissing)
      end

      it 'returns a hash' do
        expect(zc.dashboard_meetings(args)).to be_kind_of(Hash)
      end

      it "returns 'next_page_token'" do
        expect(response['next_page_token']).to be_kind_of(String)
      end

      it "returns 'total_records'" do
        expect(response['total_records']).to eq(1)
      end

      it "returns 'meetings' Array" do
        expect(response['meetings']).to be_kind_of(Array)
      end
    end

    context 'with 300 response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/metrics/meetings')
        ).to_return(status: 300,
                    body: '{ "code": 300, "message": "Can not access webinar info, {meetingId}" }',
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end

  end

end
