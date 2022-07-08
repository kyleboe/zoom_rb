# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { id: 'eIimBAXqSrWOcB_EOIXTog', status: 'activate' } }

  describe '#user_status_update' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/users/#{args[:id]}/status")
        ).to_return(status: 204,
                    body: json_response('user', 'update_status'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires id param' do
        expect { zc.user_status_update(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it 'returns the http status code as a number' do
        expect(zc.user_status_update(args)).to eql(204)
      end
    end

    context 'with a 400 response' do
      before :each do
        stub_request(
            :patch,
            zoom_url("/users/#{args[:id]}/status")
        ).to_return(status: 400,
                    body: json_response('error', 'admin_cannot_activated'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { zc.user_status_update(args) }.to raise_error(Zoom::BadRequest)
      end
    end

    context 'with a 404 response' do
      before :each do
        stub_request(
            :patch,
            zoom_url("/users/#{args[:id]}/status")
        ).to_return(status: 404,
                    body: json_response('error', 'user_not_exist'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an error' do
        expect { zc.user_status_update(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
