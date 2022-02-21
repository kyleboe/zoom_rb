# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { { meeting_id: 1, email: 'foo@bar.com', first_name: 'Foo' } }
  let(:join_url) { 'https://www.zoom.us/w/869275230' }

  describe '#meeting_add_registrant action' do
    before :each do
      stub_request(
        :post,
        zoom_url("/meetings/#{args[:meeting_id]}/registrants")
      ).to_return(body: json_response('meeting', 'add_registrant'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a hash' do
      expect(zc.meeting_add_registrant(args)).to be_kind_of(Hash)
    end

    it "returns the created user's unique registrant_id" do
      expect(zc.meeting_add_registrant(args)['registrant_id']).to eql('555')
    end

    it 'returns a join_url' do
      expect(zc.meeting_add_registrant(args)['join_url']).to eql(join_url)
    end
  end
end
