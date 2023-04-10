# frozen_string_literal: true

require "spec_helper"

RSpec.describe Zoom::Actions::Webinar do
  %i[jwt_client oauth_client server_to_server_oauth_client].each do |client|
    describe client.to_s do
      let(:zc) { send(client) }
      let(:args) { {host_id: "test_user_id"} }

      describe "#webinar_create" do
        context "with a valid response" do
          before :each do
            stub_request(
              :post,
              zoom_url("/users/#{args[:host_id]}/webinars")
            ).to_return(body: json_response("webinar", "create"),
              headers: {"Content-Type" => "application/json"})
          end

          it "requires a 'host_id' argument" do
            expect { zc.webinar_create(filter_key(args, :host_id)) }.to raise_error(Zoom::ParameterMissing, [:host_id].to_s)
          end

          it "returns a hash" do
            expect(zc.webinar_create(args)).to be_kind_of(Hash)
          end

          it "returns the setted params" do
            res = zc.webinar_create(args)
            expect(res["host_id"]).to eq(args[:host_id])
          end

          it "returns 'start_url' and 'join_url'" do
            res = zc.webinar_create(args)

            expect(res["start_url"]).to_not be_nil
            expect(res["join_url"]).to_not be_nil
          end
        end

        context "with a 4xx response" do
          before :each do
            stub_request(
              :post,
              zoom_url("/users/#{args[:host_id]}/webinars")
            ).to_return(body: json_response("error", "validation"),
              headers: {"Content-Type" => "application/json"})
          end

          it "raises Zoom::Error exception" do
            expect { zc.webinar_create(args) }.to raise_error(Zoom::Error)
          end
        end
      end
    end
  end
end
