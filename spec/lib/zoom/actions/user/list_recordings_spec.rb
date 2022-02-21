# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { { id: 'ufR9342pRyf8ePFN92dttQ' } }

  describe '#user_recordings_list action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:id]}/recordings")
          ).to_return(status: 200,
                      body: json_response('user', 'recording', 'list'),
                      headers: { 'Content-Type' => 'application/json' })
      end

      it 'requires id param' do
        expect { zc.user_recordings_list(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, '[:id]')
      end

      it 'returns a hash' do
        expect(zc.user_recordings_list(args)).to be_kind_of(Hash)
      end

      it 'returns same params' do
        res = zc.user_recordings_list(args)

        expect(res).to have_key('from')
        expect(res).to have_key('to')
        expect(res).to have_key('total_records')
        expect(res).to have_key('meetings')
        expect(res['meetings'][0]).to have_key('host_id')
        expect(res['meetings'][0]).to have_key('topic')
        expect(res['meetings'][0]).to have_key('start_time')
        expect(res['meetings'][0]).to have_key('recording_count')
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:id]}/recordings")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.user_recordings_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
