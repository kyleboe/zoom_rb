# frozen_string_literal: true

require "spec_helper"

xdescribe Zoom::Actions::IM::Chat do
  let(:zc) { zoom_client }
  let(:args) {
    {access_token: "foobar",
     session_id: "123456",
     from: "2018-08-28",
     to: "2018-08-29"}
  }
  let(:response) { zc.chat_get(args) }

  xdescribe "#chat_get action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/chat/get")
      ).to_return(body: json_response("chat", "get"))
    end

    it "requires a 'access_token' argument" do
      expect { zc.chat_get(filter_key(args, :access_token)) }.to raise_error(ArgumentError)
    end

    it "requires a 'session_id' argument" do
      expect { zc.chat_get(filter_key(args, :session_id)) }.to raise_error(ArgumentError)
    end

    it "requires a 'from' argument" do
      expect { zc.chat_get(filter_key(args, :from)) }.to raise_error(ArgumentError)
    end

    it "requires a 'to' argument" do
      expect { zc.chat_get(filter_key(args, :to)) }.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(response).to be_kind_of(Hash)
    end

    it "returns an Array of chat_messages" do
      expect(response["chat_messages"]).to be_kind_of(Array)
    end

    it "returns the params" do
      expect(response["session_id"]).to eql(args[:session_id])
      expect(response["from"]).to eql(args[:from])
      expect(response["to"]).to eql(args[:to])
    end
  end

  xdescribe "#chat_get! action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/chat/get")
      ).to_return(body: json_response("error"))
    end

    it "raises Zoom::Error exception" do
      expect { zc.chat_get!(args) }.to raise_error(Zoom::Error)
    end
  end
end
