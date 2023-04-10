# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Account do
  let(:zc) { zoom_client }
  let(:args) {
    {
      first_name: "Foo",
      last_name: "Barton",
      email: "foo@bar.com",
      password: "password1"
    }
  }
  let(:options) {
    {
      options: {
        share_rc: true,
        room_connectors: "127.0.0.1",
        share_mc: true,
        meeting_connectors: "127.0.0.1",
        pay_mode: "master"
      }
    }
  }
  describe "#account_create action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/accounts")
        ).to_return(body: json_response("account", "create"),
          headers: {"Content-Type" => "application/json"})
      end

      it "returns a hash" do
        expect(zc.account_create(args)).to be_kind_of(Hash)
      end

      it "allows options" do
        expect(zc.account_create(args.merge(options))).to be_kind_of(Hash)
      end

      it "raises an error when additional params are supplied" do
        expect { zc.account_create(args.merge(options.merge(foo: "bar"))) }.to raise_error(Zoom::ParameterNotPermitted, [:foo].to_s)
      end

      it "raises an error when missing a required param" do
        expect { zc.account_create(args.slice(*%i[first_name last_name email])) }.to raise_error(Zoom::ParameterMissing, [:password].to_s)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/accounts")
        ).to_return(status: 400,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.account_create(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
