# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 1, action: 'approve' } }

  describe '#webinar_registrants_status_update' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :put,
          zoom_url("/meetingss/#{args[:meeting_id]}/registrants/status")
        ).to_return(status: 204)
      end

      it "requires a 'meeting_id' argument" do
        expect { zc.meeting_registrants_status_update(filter_key(args, :meeting_id)) }.to raise_error(Zoom::ParameterMissing, [:meeting_id].to_s)
      end

      it "requires a 'action' argument" do
        expect { zc.meeting_registrants_status_update(filter_key(args, :action)) }.to raise_error(Zoom::ParameterMissing, [:action].to_s)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :put,
          zoom_url("/meetings/#{args[:meeting_id]}/registrants/status")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.meeting_registrants_status_update(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
