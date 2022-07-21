# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::IM::Chat do
  let(:zc) { zoom_client }
  let(:args) { { channel_id: 999999999 } }
  let(:missed_channel_args) { { channel_id: 1000000 } }
  let(:missed_channel_response) { zc.get_chat_channels(missed_channel_args) }

  describe '#get_chat_channels action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/chat/channels/#{args[:channel_id]}")
        ).to_return(body: json_response('chat', 'channels', 'get'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'channel_id' argument" do
        expect { zc.get_chat_channels }.to raise_error(Zoom::ParameterMissing, [:channel_id].to_s)
      end

      it 'returns a hash' do
        expect(zc.get_chat_channels(args)).to be_kind_of(Hash)
      end
    end

    context 'with a 400 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/chat/channels/#{args[:channel_id]}")
        ).to_return(status: 400,
                    body: json_response('error', 'unauthorized_request'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.get_chat_channels(args) }.to raise_error(Zoom::BadRequest, {
          base: "Unauthorized request. You do not have permission to access this user’s channel information."
        }.to_s)
      end
    end

    context 'with a 404 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/chat/channels/#{missed_channel_args[:channel_id]}")
        ).to_return(status: 404,
                    body: json_response('error', 'channel_not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a hash 404' do
        expect { zc.get_chat_channels(missed_channel_args) }.to raise_error(Zoom::Error, {
          base: "Channel does not exist: #{missed_channel_args[:channel_id]}"
        }.to_s)
      end
    end
  end
end
