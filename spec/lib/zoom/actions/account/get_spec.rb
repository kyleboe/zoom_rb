# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Account do
  let(:zc) { zoom_client }
  let(:args) { {account_id: 1} }

  describe "#account_get action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}")
        ).to_return(body: json_response("account", "get"),
          headers: {"Content-Type" => "application/json"})
      end

      it "returns a hash" do
        expect(zc.account_get(args)).to be_kind_of(Hash)
      end

      it "raises an error when missing a required param" do
        expect { zc.account_get }.to raise_error(Zoom::ParameterMissing, [:account_id].to_s)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts/#{args[:account_id]}")
        ).to_return(status: 400,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.account_get(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
