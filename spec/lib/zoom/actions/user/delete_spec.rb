# frozen_string_literal: true

require "spec_helper"

describe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) { {id: "eIimBAXqSrWOcB_EOIXTog"} }

  describe "#user_delete" do
    context "with a 204 response" do
      before :each do
        stub_request(
          :delete,
          zoom_url("/users/#{args[:id]}")
        ).to_return(status: 204,
          body: json_response("user", "delete"),
          headers: {"Content-Type" => "application/json"})
      end

      it "requires id param" do
        expect { zc.user_delete(filter_key(args, :id)) }.to raise_error(Zoom::ParameterMissing, [:id].to_s)
      end

      it "returns the http status code as a number" do
        expect(zc.user_delete(args)).to eql(204)
      end
    end

    context "with a 4xx when the user is not found" do
      before :each do
        stub_request(
          :delete,
          zoom_url("/users/#{args[:id]}")
        ).to_return(status: 404,
          body: json_response("error", "not_found"),
          headers: {"Content-Type" => "application/json"})
      end

      it "raises an error" do
        expect { zc.user_delete(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end
