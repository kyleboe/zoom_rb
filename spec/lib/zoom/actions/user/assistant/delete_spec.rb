# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { {user_id: "eIimBAXqSrWOcB_EOIXTog", assistant_id: "555"} }

  describe "#user_assistants_delete" do
    context "with a 204 response" do
      before :each do
        stub_request(
          :delete,
          zoom_url("/users/#{args[:user_id]}/assistants/#{args[:assistant_id]}")
        ).to_return(status: 204)
      end

      it "requires user_id param" do
        expect do
          zc.user_assistants_delete(filter_key(args, :user_id))
        end.to raise_error(Zoom::ParameterMissing, [:user_id].to_s)
      end

      it "requires assistant_id param" do
        expect do
          zc.user_assistants_delete(filter_key(args, :assistant_id))
        end.to raise_error(Zoom::ParameterMissing, [:assistant_id].to_s)
      end

      it "returns the http status code as a number" do
        expect(zc.user_assistants_delete(args)).to eql(204)
      end
    end

    context "with a 4xx when the user is not found" do
      before :each do
        stub_request(
          :delete,
          zoom_url("/users/#{args[:user_id]}/assistants/#{args[:assistant_id]}")
        ).to_return(status: 404,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises an error" do
        expect { zc.user_assistants_delete(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
