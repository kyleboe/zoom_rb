# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Meeting do
  subject(:meeting_invitation) { zoom_client.meeting_invitation(args) }

  let(:args) { { meeting_id: 91538056781 } }

  describe '#meeting_invitation action' do
    before do
      stub_request(
        :get, zoom_url("/meetings/#{args[:meeting_id]}/invitation")
      ).to_return(
        status: 200,
        body: json_response('meeting', 'invitation'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    context 'without :meeting_id parameter provided' do
      let(:args) { {} }

      it "requires a 'meeting_id' argument" do
        expect { meeting_invitation }.to(
          raise_error(Zoom::ParameterMissing, %i[meeting_id].to_s)
        )
      end
    end

    context 'when meeting_id parameter provided' do
      let(:invitation) do
        "Team Member is inviting you to a scheduled Zoom meeting.\r\n\r\n"\
        "Topic: Test meeting\r\nTime: Sep 17, 2020 03:49 PM Kiev\r\n\r\n"\
        "Join Zoom Meeting\r\nhttps://zoom.us/j/9451234446749?pwd=K3AwTGtdUVdqSnNVWnd6MaZxZnZEdz09\r\n\r\n"\
        "Meeting ID: 943 1234 6721\r\nPasscode: DgA4yb\r\n\r\n"
      end

      it 'returns a hash' do
        expect(meeting_invitation).to be_kind_of(Hash)
      end

      it 'returns id and attributes' do
        expect(meeting_invitation['invitation']).to eq(invitation)
      end
    end
  end
end
