# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Roles do
  let(:zc) { zoom_client }
  let(:args) { {role_id: "RMWJ20fcKS8Wsgp_Tu4todg", member_id: "x-chC53ZRJ6_fO29-a5WrA"} }

  describe "#roles_unassign action" do
    before :each do
      stub_request(
        :delete,
        zoom_url("/roles/RMWJ20fcKS8Wsgp_Tu4todg/members/x-chC53ZRJ6_fO29-a5WrA")
      ).to_return(status: 204)
    end

    it "requires role_id param" do
      expect {
        zc.roles_unassign(filter_key(args, :role_id))
      }.to raise_error(Zoom::ParameterMissing, [:role_id].to_s)
    end

    it "requires member_id param" do
      expect {
        zc.roles_unassign(filter_key(args, :member_id))
      }.to raise_error(Zoom::ParameterMissing, [:member_id].to_s)
    end

    it "returns the http status code as a number" do
      expect(zc.roles_unassign(args)).to eql(204)
    end
  end
end
