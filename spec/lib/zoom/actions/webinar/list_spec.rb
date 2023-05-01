# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { {host_id: "test_user_id"} }

  describe "#webinar_list" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:host_id]}/webinars")
        ).to_return(body: json_response("webinar", "list"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires a 'host_id' argument" do
        expect { zc.webinar_list }.to raise_error(Zoom::ParameterMissing, [:host_id].to_s)
      end

      it "returns a hash" do
        expect(zc.webinar_list(args)).to be_kind_of(Hash)
      end

      it "returns 'total_records'" do
        expect(zc.webinar_list(args)["total_records"]).to eq(1)
      end

      it "returns 'webinars' Array" do
        expect(zc.webinar_list(args)["webinars"]).to be_kind_of(Array)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:host_id]}/webinars")
        ).to_return(body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.webinar_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
