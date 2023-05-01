# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Account do
  let(:zc) { zoom_client }
  let(:args) {
    {}
  }
  describe "#account_list action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts")
        ).to_return(body: json_response("account", "list"),
          headers: {"Content-Type" => "application/json"})
      end

      it "returns a hash" do
        expect(zc.account_list(args)).to be_kind_of(Hash)
      end

      it "allows 'page_size and page_numbers" do
        args[:page_number] = 1
        args[:page_size] = 30
        expect(zc.account_list(args)).to be_kind_of(Hash)
      end

      it "returns 'total_records" do
        expect(zc.account_list(args)["total_records"]).to eq(1)
      end

      it "returns 'accounts' Array" do
        expect(zc.account_list(args)["accounts"]).to be_kind_of(Array)
      end

      it "raises an error when passed an invalid option" do
        expect { zc.account_list(foo: "bar") }.to raise_error(Zoom::ParameterNotPermitted, [:foo].to_s)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/accounts")
        ).to_return(status: 404,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.account_list }.to raise_error(Zoom::Error)
      end
    end
  end
end
