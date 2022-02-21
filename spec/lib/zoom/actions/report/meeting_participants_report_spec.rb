# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Report do
  let(:zc) { zoom_client }
  let(:args) { { id: '123456789' } }

  describe '#meeting_participants_report' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/report/meetings/#{args[:id]}/participants")
        ).to_return(status: 200,
                    body: json_response('report', 'meeting', 'participants'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'id' argument" do
        expect { zc.meeting_participants_report(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it 'returns an array of participants' do
        expect(zc.meeting_participants_report(args)['participants']).to be_kind_of(Array)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/report/meetings/#{args[:id]}/participants")
        ).to_return(status: 404,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { zc.meeting_participants_report(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
