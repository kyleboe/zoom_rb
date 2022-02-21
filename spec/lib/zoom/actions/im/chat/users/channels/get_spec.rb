# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::IM::Chat do
  let(:zc) { zoom_client }
  let(:args) { { user_id: 555 } }

  describe '#get_chat_user_channels action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/chat/users/#{args[:user_id]}/channels")
        ).to_return(body: json_response('chat', 'users', 'channels', 'list'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'user_id' argument" do
        expect { zc.get_chat_user_channels }.to raise_error(Zoom::ParameterMissing, [:user_id].to_s)
      end

      it 'returns a hash' do
        expect(zc.get_chat_user_channels(args)).to be_kind_of(Hash)
      end
    end

    context 'with a 400 response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/chat/users/#{args[:user_id]}/channels")
        ).to_return(status: 400,
                    body: json_response('error', 'next_page_token_invalid'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception with text' do
        expect { zc.get_chat_user_channels(args) }.to raise_error(Zoom::Error, {
          base: 'The next page token is either invalid or has expired.'
        }.to_s)
      end
    end
  end
end
