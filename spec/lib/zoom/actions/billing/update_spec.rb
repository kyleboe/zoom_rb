# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Billing do
  let(:zc) { zoom_client }
  let(:required_args) { { account_id: '1' } }
  let(:permitted_args) {
    {
      first_name: 'Foo',
      last_name: 'Bar',
      email: 'foo@bar.com',
      phone_number: '1234567890',
      address: '123 Test Street',
      apt: '',
      city: 'Vancouver',
      state: 'WA',
      zip: '98660',
      country: 'US'
    }
  }
  let(:args) { required_args.merge(permitted_args) }

  describe '#billing_update action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/accounts/#{args[:account_id]}/billing")
          ).to_return(status: 204,
                      body: json_response('billing', 'update'),
                      headers: { 'Content-Type' => 'application/json' })
      end

      it 'makes the request' do
        zc.billing_update(args)
        expect(WebMock).to have_requested(:patch, zoom_url("/accounts/#{args[:account_id]}/billing")).with(body: permitted_args.to_json, headers: request_headers)
      end

      it 'requires id param' do
        expect { zc.billing_update }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end

      it 'returns a success response' do
        expect(zc.billing_update(args)).to eql(204)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/accounts/#{args[:account_id]}/billing")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.billing_update(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
