# frozen_string_literal: true

require "spec_helper"

xdescribe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { {host_id: "ufR93M2pRyy8ePFN92dttq"} }

  xdescribe "#meeting_list action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/meeting/list")
      ).to_return(body: json_response("meeting", "list"))
    end

    it "requires a 'host_id' argument" do
      expect { zc.meeting_list }.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(zc.meeting_list(args)).to be_kind_of(Hash)
    end

    it "returns 'total_records'" do
      expect(zc.meeting_list(args)["total_records"]).to eq(235)
    end

    it "returns 'meetings' Array" do
      expect(zc.meeting_list(args)["meetings"]).to be_kind_of(Array)
    end
  end

  xdescribe "#meeting_list! action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/meeting/list")
      ).to_return(body: json_response("error"))
    end

    it "raises Zoom::Error exception" do
      expect {
        zc.meeting_list!(args)
      }.to raise_error(Zoom::Error)
    end
  end
end
