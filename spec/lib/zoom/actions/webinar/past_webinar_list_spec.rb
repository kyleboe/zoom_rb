# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { {id: "123456789"} }

  describe "#past_webinar_list" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/past_webinars/#{args[:id]}/instances")
        ).to_return(status: 200,
          body: json_response("webinar", "past_webinar_list"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires a 'id' argument" do
        expect { zc.past_webinar_list(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it "returns a list of webinar instances as an array" do
        expect(zc.past_webinar_list(args)["webinars"]).to be_kind_of(Array)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/past_webinars/#{args[:id]}/instances")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.past_webinar_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
