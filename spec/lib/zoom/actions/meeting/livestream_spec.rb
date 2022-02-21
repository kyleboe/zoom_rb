# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: '3qn1231nd', stream_url: 'owuj2n323hdns', stream_key: 'w02KPjeena' } }
  let(:response) { zc.livestream(args) }

  describe '#livestream action' do
    context 'with 204 response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/meetings/#{args[:meeting_id]}/livestream")
        ).to_return(status: 204,
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires meeting_id param" do
        expect {
          zc.livestream(filter_key(args, :meeting_id))
        }.to raise_error(Zoom::ParameterMissing, [:meeting_id].to_s)
      end

      it 'returns a hash' do
        expect(response).to eq(204)
      end
    end

    context 'with 300 response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/meetings/#{args[:meeting_id]}/livestream")
        ).to_return(status: 300,
                    body: json_response('meeting', 'live_stream', 'errors', 'missing_field'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end

    context 'with 404 response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/meetings/#{args[:meeting_id]}/livestream")
        ).to_return(status: 404,
                    body: json_response('meeting', 'live_stream', 'errors', 'meeting_not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end
  end
end
