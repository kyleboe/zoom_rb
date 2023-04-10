# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { {id: "ufR9342pRyf8ePFN92dttQ"} }

  describe "#settings_get action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:id]}/settings")
        ).to_return(status: 200,
          body: json_response("user", "settings_get"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires id param" do
        expect { zc.user_settings_get(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, "[:id]")
      end

      it "allowes login_type" do
        args[:login_type] = 0
        expect { zc.user_settings_get(args) }.not_to raise_error
      end

      it "returns a hash" do
        expect(zc.user_settings_get(args)).to be_kind_of(Hash)
      end

      it "returns same params" do
        res = zc.user_settings_get(args)

        expect(res.keys).to match_array(["scheduled_meeting", "in_meeting", "email_notification", "recording", "telephony", "tsp", "feature"])
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:id]}/settings")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.user_settings_get(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
