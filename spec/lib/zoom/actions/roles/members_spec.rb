# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Roles do
  let(:zc) { zoom_client }
  let(:args) { {role_id: 2} }

  describe "#roles_members action" do
    before :each do
      stub_request(
        :get,
        zoom_url("/roles/2/members")
      ).to_return(body: json_response("roles", "members"), headers: {"Content-Type" => "application/json"})
    end

    it "requires role_id param" do
      expect {
        zc.roles_members(filter_key(args, :role_id))
      }.to raise_error(Zoom::ParameterMissing, [:role_id].to_s)
    end

    it "returns a hash" do
      expect(zc.roles_members(args)).to be_kind_of(Hash)
    end

    it "returns 'total_records'" do
      expect(zc.roles_members(args)["total_records"]).to eq(1)
    end

    it "returns 'roles' Array" do
      expect(zc.roles_members(args)["members"]).to be_kind_of(Array)
    end
  end
end
