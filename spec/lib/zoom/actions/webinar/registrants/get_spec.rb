# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { {webinar_id: "webinar_id", id: "registrant_id"} }

  describe "#webinar_registrant_get" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/registrants/#{args[:id]}")
        ).to_return(body: json_response("webinar", "registrant", "get"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires a 'webinar_id' argument" do
        expect { zc.webinar_registrant_get(filter_key(args, :webinar_id)) }.to raise_error(Zoom::ParameterMissing, [:webinar_id].to_s)
      end
      it "requires a 'id' argument" do
        expect { zc.webinar_registrant_get(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end
      it "allows occurrence_id" do
        expect { zc.webinar_registrant_get(args.merge(occurrence_id: "5")) }.not_to raise_error
      end

      it "returns an Hash" do
        expect(zc.webinar_registrant_get(args)).to be_kind_of(Hash)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/registrants/#{args[:id]}")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.webinar_registrant_get(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
