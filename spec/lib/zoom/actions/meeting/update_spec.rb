# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { {meeting_id: 91538056781, topic: "Updated Topic"} }

  describe "#meeting_update action" do
    context "with 204 response" do
      before :each do
        stub_request(
          :patch,
          zoom_url("/meetings/#{args[:meeting_id]}")
        ).to_return(
          status: 204,
          headers: {"Content-Type" => "application/json"}
        )
      end

      it "requires a 'meeting_id' argument" do
        expect {
          zc.meeting_update(filter_key(args, :meeting_id))
        }.to raise_error(Zoom::ParameterMissing, [:meeting_id].to_s)
      end

      it "returns a status code" do
        expect(zc.meeting_update(args)).to eq 204
      end
    end

    context "with 404 response" do
      before :each do
        stub_request(
          :patch,
          zoom_url("/meetings/invalid-meeting-id")
        ).to_return(
          status: 404,
          body: json_response("error", "meeting_not_exist"),
          headers: {"Content-Type" => "application/json"}
        )
      end

      it "raises an error" do
        expect {
          zc.meeting_update(args.merge(meeting_id: "invalid-meeting-id"))
        }.to raise_error(Zoom::Error, {base: "Invalid meeting id."}.to_s)
      end
    end
  end

  describe "#meeting_update! action" do
    it "raises NoMethodError exception" do
      expect {
        zc.meeting_update!(args)
      }.to raise_error(NoMethodError)
    end
  end
end
