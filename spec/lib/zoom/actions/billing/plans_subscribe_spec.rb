# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Billing do
  let(:zc) { zoom_client }
  let(:url_args) { { account_id: '1' } }
  let(:required_args) {
    {
      contact: {
        first_name: 'Foo',
        last_name: 'Bar',
        email: 'foo@bar.com',
        phone_number: '1234567890',
        address: '123 Test St',
        apt: 'A',
        city: 'Vancouver',
        state: 'WA',
        zip: '98660',
        country: 'US'
      },
      plan_base: {
        type: 'monthly',
        hosts: 10
      }
    }
  }
  let(:args) { url_args.merge(required_args) }

  describe '#billing_plans_subscribe action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/accounts/#{args[:account_id]}/plans")
        ).to_return(body: json_response('billing', 'plans_subscribe'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'makes the request' do
        zc.billing_plans_subscribe(args)
        expect(WebMock).to have_requested(:post, zoom_url("/accounts/#{args[:account_id]}/plans")).with(body: required_args.to_json, headers: request_headers)
      end

      it 'returns a hash' do
        expect(zc.billing_plans_subscribe(args)).to be_kind_of(Hash)
      end

      it 'raises an error when missing a required param' do
        expect { zc.billing_plans_subscribe(required_args) }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/accounts/#{args[:account_id]}/plans")
        ).to_return(status: 400,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.billing_plans_subscribe(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
