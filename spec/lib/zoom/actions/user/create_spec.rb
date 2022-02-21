# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) do
    {
      action: 'create',
      user_info: {
        email: 'foo@bar.com',
        type: 1,
        first_name: 'Zoomie',
        last_name: 'Userton',
        password: 'testerino'
      }
    }
  end

  describe '#user_create' do
    context 'with 201 response' do
      before :each do
        stub_request(
          :post,
          zoom_url('/users')
        ).to_return(status: 201,
                    body: json_response('user', 'create'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires action param' do
        expect { zc.user_create(filter_key(args, :action)) }.to raise_error(Zoom::ParameterMissing, [:action].to_s)
      end

      it 'requires email param' do
        args[:user_info].delete(:email)
        expect { zc.user_create(args) }.to raise_error(Zoom::ParameterMissing, [{user_info: [:email]}].to_s)
      end

      it 'requires type param' do
        args[:user_info].delete(:type)
        expect { zc.user_create(args) }.to raise_error(Zoom::ParameterMissing, [{user_info: [:type]}].to_s)
      end

      it 'returns a hash' do
        expect(zc.user_create(args)).to be_kind_of(Hash)
      end

      it 'returns same params' do
        res = zc.user_create(args)

        expect(res['email']).to eq(args[:user_info][:email])
        expect(res['first_name']).to eq(args[:user_info][:first_name])
        expect(res['last_name']).to eq(args[:user_info][:last_name])
        expect(res['type']).to eq(args[:user_info][:type])
      end
    end

    context 'with 409 response' do
      before :each do
        stub_request(
          :post,
          zoom_url('/users')
        ).to_return(status: 409,
                    body: json_response('error', 'already_exists'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { zc.user_create(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
