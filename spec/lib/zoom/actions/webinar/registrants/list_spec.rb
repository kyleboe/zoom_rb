# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { {id: "webinar_id"} }

  describe "#webinar_registrants_list" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:id]}/registrants")
        ).to_return(body: json_response("webinar", "registrant", "list"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires a 'id' argument" do
        expect { zc.webinar_registrants_list(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it "returns an Array of registrants" do
        expect(zc.webinar_registrants_list(args)["registrants"]).to be_kind_of(Array)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:id]}/registrants")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.webinar_registrants_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
