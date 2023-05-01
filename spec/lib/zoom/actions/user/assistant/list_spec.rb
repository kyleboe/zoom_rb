# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { {user_id: "ufR93M2pRyy8ePFN92dttq"} }

  describe "#user_assistants_list action" do
    context "with a valid response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:user_id]}/assistants")
        ).to_return(body: json_response("user", "assistant", "list"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires user_id param" do
        expect {
          zc.user_assistants_list(filter_key(args, :user_id))
        }.to raise_error(Zoom::ParameterMissing, [:user_id].to_s)
      end

      it "returns a hash" do
        expect(zc.user_assistants_list(args)).to be_kind_of(Hash)
      end

      it "returns 'assistants' count" do
        expect(zc.user_assistants_list(args)["assistants"].count).to eq(1)
      end

      it "returns 'assistants' Array" do
        expect(zc.user_assistants_list(args)["assistants"]).to be_kind_of(Array)
      end
    end

    context "with a 4xx response" do
      before :each do
        stub_request(
          :get,
          zoom_url("/users/#{args[:user_id]}/assistants")
        ).to_return(status: 404,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises Zoom::Error exception" do
        expect { zc.user_assistants_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
