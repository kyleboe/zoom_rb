# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { { webinar_id: 'foo', poll_id: 'bar' } }

  describe '#webinar_poll_get' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/polls/#{args[:poll_id]}")
        ).to_return(status: :ok,
                    body: json_response('webinar', 'poll_get'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'webinar_id' argument" do
        expect { zc.webinar_poll_get(filter_key(args, :webinar_id)) }.to raise_error(Zoom::ParameterMissing, [:webinar_id].to_s)
      end

      it "requires a 'poll_id' argument" do
        expect { zc.webinar_poll_get(filter_key(args, :poll_id)) }.to raise_error(Zoom::ParameterMissing, [:poll_id].to_s)
      end

      it 'returns a hash' do
        expect(zc.webinar_poll_get(args)).to be_a(Hash)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/polls/#{args[:poll_id]}")
        ).to_return(body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.webinar_poll_get(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
