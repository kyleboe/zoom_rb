# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Account do
  let(:zc) { zoom_client }
  let(:args) {
    {
      account_id: "1",
      schedule_meeting: {
        host_video: true
      }
    }
  }

  describe "#settings_update action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :patch,
          zoom_url("/accounts/#{args[:account_id]}/settings")
        ).to_return(status: 204,
          body: json_response("account", "settings_update"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires id param" do
        expect { zc.account_settings_update }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end

      it "raises an error when passed an invalid param" do
        expect { zc.account_settings_update(args.merge(foo: "bar")) }.to raise_error(Zoom::ParameterNotPermitted, [:foo].to_s)
      end

      it "returns a 204 successful response" do
        expect(zc.account_settings_update(args)).to eql(204)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :patch,
          zoom_url("/accounts/#{args[:account_id]}/settings")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.account_settings_update(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
