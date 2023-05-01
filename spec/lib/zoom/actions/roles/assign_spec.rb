# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Roles do
  let(:zc) { zoom_client }
  let(:args) { {role_id: "RHLWWwtVZRnuq7OctVApqlg", members: [{id: "sdkjsfdffds"}, {id: "dsfdsgrdgt"}]} }

  describe "#roles_assign action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/roles/RHLWWwtVZRnuq7OctVApqlg/members")
      ).to_return(body: json_response("roles", "assign"), headers: {"Content-Type" => "application/json"})
    end

    it "returns a hash" do
      expect(zc.roles_assign(args)).to be_kind_of(Hash)
    end

    it "returns 'ids' Array" do
      expect(zc.roles_assign(args)["ids"]).to be_kind_of(Array)
    end
  end
end
