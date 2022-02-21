# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { vanity_name: 'foobar' } }

  describe '#user_vanity_name action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/users/vanity_name')
        ).to_return(status: 200,
                    body: json_response('user', 'vanity_name'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires vanity_name param' do
        expect { zc.user_vanity_name(filter_key(args, :vanity_name)) }
          .to raise_error(Zoom::ParameterMissing, '[:vanity_name]')
      end

      it 'returns a hash' do
        expect(zc.user_vanity_name(args)).to be_kind_of(Hash)
      end

      it 'returns expected value' do
        res = zc.user_vanity_name(args)

        expect(res['existed']).to be true
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/users/vanity_name')
        ).to_return(status: 400,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.user_vanity_name({ vanity_name: '' }) }.to raise_error(Zoom::Error)
      end
    end
  end
end
