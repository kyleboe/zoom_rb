# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { { webinar_id: '123456789' } }

  describe '#webinar_polls_list' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/polls")
        ).to_return(status: :ok,
                    body: json_response('webinar', 'polls_list'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'webinar_id' argument" do
        expect { zc.webinar_polls_list(filter_key(args, :webinar_id)) }.to raise_error(Zoom::ParameterMissing, [:webinar_id].to_s)
      end

      it 'returns the http status code as a number' do
        expect(zc.webinar_polls_list(args)['polls']).to be_an(Array)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/polls")
        ).to_return(status: 404,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { zc.webinar_polls_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
