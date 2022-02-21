# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { id: 'eIimBAXqSrWOcB_EOIXTog', password: 'new_pass' } }

  describe '#user_password_update' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :patch,
          zoom_url("/users/#{args[:id]}/password")
        ).to_return(status: 204,
                    body: json_response('user', 'update_password'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires id param' do
        expect { zc.user_password_update(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it 'returns the http status code as a number' do
        expect(zc.user_password_update(args)).to eql(204)
      end
    end
  end
end
