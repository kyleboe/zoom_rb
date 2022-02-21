# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { {} }

  describe '#user_list action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/users')
        ).to_return(body: json_response('user', 'list'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a hash' do
        expect(zc.user_list).to be_kind_of(Hash)
      end

      it "returns 'total_records" do
        expect(zc.user_list['total_records']).to eq(1)
      end

      it "returns 'users' Array" do
        expect(zc.user_list['users']).to be_kind_of(Array)
      end

      it 'allows status' do
        args[:status] = 'active'
        expect { zc.user_list(args) }.not_to raise_error
      end

      it 'allows page_size' do
        args[:page_size] = 30
        expect { zc.user_list(args) }.not_to raise_error
      end

      it 'allows role_id' do
        args[:role_id] = '1'
        expect { zc.user_list(args) }.not_to raise_error
      end

      it 'allows page_number' do
        args[:page_number] = 1
        expect { zc.user_list(args) }.not_to raise_error
      end

      it 'allows include_fields' do
        args[:include_fields] = 'host_key'
        expect { zc.user_list(args) }.not_to raise_error
      end

      it 'next_page_token' do
        args[:next_page_token] = 'some_token'
        expect { zc.user_list(args) }.not_to raise_error
      end

      it 'raises an error when passed an invalid parameter' do
        expect { zc.user_list(foo: 'bar', status: 'active') }.to raise_error(Zoom::ParameterNotPermitted, [:foo].to_s)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url('/users')
        ).to_return(status: 404,
                    body: json_response('error', 'not_found'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.user_list }.to raise_error(Zoom::Error)
      end
    end
  end
end
