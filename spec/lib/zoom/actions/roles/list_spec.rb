# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::Roles do
  let(:zc) { zoom_client }

  describe "#roles_list action" do
    before :each do
      stub_request(
        :get,
        zoom_url("/roles")
      ).to_return(body: json_response("roles", "list"), headers: {"Content-Type" => "application/json"})
    end

    it "returns a hash" do
      expect(zc.roles_list).to be_kind_of(Hash)
    end

    it "returns 'total_records'" do
      expect(zc.roles_list["total_records"]).to eq(4)
    end

    it "returns 'roles' Array" do
      expect(zc.roles_list["roles"]).to be_kind_of(Array)
    end
  end
end
