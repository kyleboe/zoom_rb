# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Roles do
  let(:zc) { zoom_client }
  let(:args) {
    {
      name: "Group Administrator",
      description: "A person with this role can view and manage groups.",
      privileges: [
        "User:Read"
      ]
    }
  }
  let(:response) { zc.roles_create(args) }

  describe "#roles_create action" do
    context "with 201 response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/roles")
        ).to_return(status: 201,
          body: json_response("roles", "create"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires name param" do
        expect {
          zc.roles_create(filter_key(args, :name))
        }.to raise_error(Zoom::ParameterMissing, [:name].to_s)
      end

      it "requires name param" do
        expect {
          zc.roles_create(args)
        }.not_to raise_error
      end

      it "returns a hash" do
        expect(response).to be_kind_of(Hash)
      end

      it "returns the set params" do
        expect(response["name"]).to eq(args[:name])
        expect(response["description"]).to eq(args[:description])
        expect(response["privileges"]).to eq(args[:privileges])
      end

      it "returns 'total_members' and 'id'" do
        expect(response["id"]).to_not be_nil
        expect(response["total_members"]).to_not be_nil
      end
    end
  end
end
