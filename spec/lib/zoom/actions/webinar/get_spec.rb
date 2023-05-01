# frozen_string_literal: true

require "spec_helper"

xdescribe Zoom::Actions::Webinar do
  before :all do
    @zc = zoom_client
    @args = {
      host_id: "dh23hdu23gd",
      id: "123456789"
    }
  end

  xdescribe "#webinar_get action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/webinar/get")
      ).to_return(body: json_response("webinar_get"),
        headers: {"Content-Type" => "application/json"})
    end

    it "requires a 'host_id' argument" do
      expect {
        @zc.meeting_create(filter_key(@args, :host_id))
      }.to raise_error(ArgumentError)
    end

    it "requires a 'id' argument" do
      expect {
        @zc.meeting_create(filter_key(@args, :id))
      }.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(@zc.webinar_get(@args)).to be_kind_of(Hash)
    end

    it "returns id and attributes" do
      res = @zc.webinar_get(@args)

      expect(res["id"]).to eq(@args[:id])
      expect(res["host_id"]).to eq(@args[:host_id])
      expect(res["topic"]).to eq("Topic for this meeting")
      expect(res["start_time"]).to eq("2012-11-25T12:00:00Z")
      expect(res["join_url"]).to eq("https://zoom.us/j/123456789")
      expect(res["start_url"]).to eq("https://zoom.us/s/123456789?zpk=hs65q23kd9sqliy612h23k")
    end
  end

  xdescribe "#webinar_get! action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/webinar/get")
      ).to_return(body: json_response("error"))
    end

    it "raises Zoom::Error exception" do
      expect {
        @zc.webinar_get!(@args)
      }.to raise_error(Zoom::Error)
    end
  end
end
