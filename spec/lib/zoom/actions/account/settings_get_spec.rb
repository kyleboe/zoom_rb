# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Account do
  let(:zc) { zoom_client }
  let(:args) { {account_id: "1"} }

  describe "#settings_get action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/settings")
        ).to_return(status: 200,
          body: json_response("account", "settings_get"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires id param" do
        expect { zc.account_settings_get }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end

      it "returns a hash" do
        expect(zc.account_settings_get(args)).to be_kind_of(Hash)
      end

      it "returns same params" do
        res = zc.account_settings_get(args)

        expect(res.keys).to match_array(%w[email_notification feature in_meeting integration recording schedule_meeting security telephony tsp zoom_rooms])
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}/settings")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.account_settings_get(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
