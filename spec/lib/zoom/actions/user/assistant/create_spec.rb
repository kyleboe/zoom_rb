# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:assistant_foo) { {id: "foo", email: "foo@bar.bas"} }
  let(:args) { {user_id: "ufR93M2pRyy8ePFN92dttq", assistants: [assistant_foo]} }
  let(:response) { zc.user_assistants_create(args) }

  describe "#user_assistants_create action" do
    context "with 201 response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/users/#{args[:user_id]}/assistants")
        ).to_return(status: 201,
          body: json_response("user", "assistant", "create"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires user_id param" do
        expect {
          zc.user_assistants_create(filter_key(args, :user_id))
        }.to raise_error(Zoom::ParameterMissing, [:user_id].to_s)
      end

      it "requires user_id param" do
        expect {
          zc.user_assistants_create(args)
        }.not_to raise_error
      end

      it "returns a hash" do
        expect(response).to be_kind_of(Hash)
      end

      it "returns 'ids' and 'add_at'" do
        expect(response["ids"]).to eq "foo"
        expect(response["add_at"]).to eq "2020-04-08T12:00:00Z"
      end
    end

    context "with 404 response" do
      before :each do
        stub_request(
          :post,
          zoom_url("/users/#{args[:user_id]}/assistants")
        ).to_return(status: 404,
          body: json_response("error", "user_not_exist"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises an error" do
        expect { response }.to raise_error(Zoom::Error)
      end
    end
  end
end
