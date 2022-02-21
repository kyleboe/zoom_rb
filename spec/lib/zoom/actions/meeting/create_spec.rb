# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { { topic: 'Zoom Meeting Topic', start_time: '2020-05-05T21:00:00Z', timezone: 'America/New_York', duration: 30, type: 2, user_id: 'r55v2FgSTVmDmVot18DX3A', template_id: 'template_id' } }
  let(:response) { zc.meeting_create(args) }

  describe '#meeting_create action' do
    context 'with 201 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/users/#{args[:user_id]}/meetings")
        ).to_return(
          status: 201,
          body: json_response('meeting','create'),
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it "requires user_id param" do
        expect {
          zc.meeting_create(filter_key(args, :user_id))
        }.to raise_error(Zoom::ParameterMissing, [:user_id].to_s)
      end

      it 'returns a hash' do
        expect(response).to be_kind_of(Hash)
      end

      it 'returns the set params' do
        expect(response['type']).to eq(args[:type])
        expect(response['topic']).to eq(args[:topic])
        expect(response['start_time']).to eq(args[:start_time])
        expect(response['duration']).to eq(args[:duration])
      end

      it "returns 'start_url' and 'join_url'" do
        expect(response['start_url']).to_not be_nil
        expect(response['join_url']).to_not be_nil
      end
    end

    context 'with 404 response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/users/#{args[:user_id]}/meetings")
        ).to_return(
          status: 404,
          body: json_response('error', 'user_not_exist'),
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'raises an error' do
        expect { response }.to raise_error(Zoom::Error)
      end
    end
  end
end
