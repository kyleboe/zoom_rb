# frozen_string_literal: true

require "spec_helper"

xdescribe Zoom::Actions::IM::Chat do
  let(:zc) { zoom_client }
  let(:args) {
    {access_token: "foobar",
     from: "2018-08-28",
     to: "2018-08-29"}
  }
  let(:response) { zc.chat_list(args) }

  xdescribe "#chat_list action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/chat/list")
      ).to_return(body: json_response("chat", "list"))
    end

    it "requires a 'access_token' argument" do
      expect { zc.chat_list(filter_key(args, :access_token)) }.to raise_error(ArgumentError)
    end

    it "requires a 'from' argument" do
      expect { zc.chat_list(filter_key(args, :from)) }.to raise_error(ArgumentError)
    end

    it "requires a 'to' argument" do
      expect { zc.chat_list(filter_key(args, :to)) }.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(response).to be_kind_of(Hash)
    end

    it "returns an Array of `chat_list`s" do
      expect(response["chat_list"]).to be_kind_of(Array)
    end

    it "returns the params" do
      expect(response["from"]).to eql(args[:from])
      expect(response["to"]).to eql(args[:to])
    end
  end

  xdescribe "#chat_list! action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/chat/list")
      ).to_return(body: json_response("error"))
    end

    it "raises Zoom::Error exception" do
      expect { zc.chat_list!(args) }.to raise_error(Zoom::Error)
    end
  end
end
