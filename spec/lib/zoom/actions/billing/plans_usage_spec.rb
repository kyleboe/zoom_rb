# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Billing do
  let(:zc) { zoom_client }
  let(:args) { { account_id: '1' } }

  describe '#billing_plans_usage action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/plans/usage")
        ).to_return(body: json_response('billing', 'plans_usage'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'makes the request' do
        zc.billing_plans_usage(args)
        expect(WebMock).to have_requested(:get, zoom_url("/accounts/#{args[:account_id]}/plans/usage")).with(headers: request_headers)
      end

      it 'returns a hash' do
        expect(zc.billing_plans_usage(args)).to be_kind_of(Hash)
      end

      it 'raises an error when missing a required param' do
        expect { zc.billing_plans_usage }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/plans/usage")
        ).to_return(status: 400,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.billing_plans_usage(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
