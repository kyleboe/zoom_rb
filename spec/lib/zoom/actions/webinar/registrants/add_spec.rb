# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) {
    {id: "webinar_id",
     first_name: "Zoomie",
     last_name: "Userton",
     email: "foo@bar.com"}
  }

  describe "#webinar_registrant_add" do
    context "with a valid response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/webinars/#{args[:id]}/registrants")
        ).to_return(status: 201,
          body: json_response("webinar", "registrant", "add"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires a 'id' argument" do
        expect { zc.webinar_registrant_add(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it "requires a 'first_name' argument" do
        expect { zc.webinar_registrant_add(filter_key(args, :first_name)) }.to raise_error(Zoom::ParameterMissing, [:first_name].to_s)
      end

      it "requires a 'last_name' argument" do
        expect { zc.webinar_registrant_add(filter_key(args, :last_name)) }.to raise_error(Zoom::ParameterMissing, [:last_name].to_s)
      end

      it "requires a 'email' argument" do
        expect { zc.webinar_registrant_add(filter_key(args, :email)) }.to raise_error(Zoom::ParameterMissing, [:email].to_s)
      end

      it "returns an Hash" do
        expect(zc.webinar_registrant_add(args)).to be_kind_of(Hash)
      end

      it 'returns a "join_url"' do
        res = zc.webinar_registrant_add(args)
        expect(res["join_url"]).not_to be nil
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/webinars/#{args[:id]}/registrants")
        ).to_return(status: 404,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.webinar_registrant_add(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
