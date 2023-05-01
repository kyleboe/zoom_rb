# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Roles do
  let(:zc) { zoom_client }
  let(:args) { {role_id: 2} }

  describe "#roles_get action" do
    before :each do
      stub_request(
        :get,
        zoom_url("/roles/2")
      ).to_return(body: json_response("roles", "get"), headers: {"Content-Type" => "application/json"})
    end

    it "returns a hash" do
      expect(zc.roles_get(args)).to be_kind_of(Hash)
    end

    it "return 'name' parameter" do
      expect(zc.roles_get(args)["name"]).not_to be_nil
    end

    it "return 'description' parameter" do
      expect(zc.roles_get(args)["description"]).not_to be_nil
    end

    it "return 'total_members' parameter" do
      expect(zc.roles_get(args)["total_members"]).to eq(2)
    end

    it "returns 'privileges' Array" do
      expect(zc.roles_get(args)["privileges"]).to be_kind_of(Array)
    end
  end
end
