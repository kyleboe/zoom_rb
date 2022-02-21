# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { email: 'test@example.com' } }

  describe '#user_email_check action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/users/email')
        ).to_return(body: json_response('user', 'email_check'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a hash' do
        expect(zc.user_email_check(args)).to be_kind_of(Hash)
      end

      it "returns 'existed_email'" do
        expect(zc.user_email_check(args)['existed_email']).to be_truthy
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/users/email')
        ).to_return(status: 404,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.user_email_check(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
