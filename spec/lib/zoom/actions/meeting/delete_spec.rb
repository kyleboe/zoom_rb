# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { {meeting_id: "91538056781"} }

  describe "#meeting_delete action" do
    before :each do
      stub_request(
        :delete,
        zoom_url("/meetings/#{args[:meeting_id]}")
      ).to_return(
        status: 204,
        headers: {"Content-Type": "application/json"}
      )
    end

    it "requires a 'meeting_id' argument" do
      expect {
        zc.meeting_delete(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing)
    end

    it "returns a status code" do
      expect(zc.meeting_delete(args)).to eq 204
    end
  end

  describe "#meeting_delete! action" do
    it "raises NoMethodError exception" do
      expect {
        zc.meeting_delete!(args)
      }.to raise_error(NoMethodError)
    end
  end
end
