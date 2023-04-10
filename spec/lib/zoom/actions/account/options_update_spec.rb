# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Account do
  let(:zc) { zoom_client }
  let(:args) {
    {
      account_id: "1",
      share_rc: true,
      room_connectors: "127.0.0.1",
      share_mc: true,
      meeting_connectors: "127.0.0.1",
      pay_mode: "master"
    }
  }

  describe "#options_update action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :patch,
          zoom_url("/accounts/#{args[:account_id]}/options")
        ).to_return(body: json_response("account", "options_update"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires id param" do
        expect { zc.account_options_update }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end

      it "returns a hash" do
        expect(zc.account_options_update(args)).to be_kind_of(Hash)
      end

      it "returns same params" do
        res = zc.account_options_update(args)

        expect(res.keys).to match_array(%w[share_rc room_connectors share_mc meeting_connectors pay_mode])
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :patch,
          zoom_url("/accounts/#{args[:account_id]}/options")
        ).to_return(status: 404,
          body: json_response("error", "validation"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.account_options_update(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
