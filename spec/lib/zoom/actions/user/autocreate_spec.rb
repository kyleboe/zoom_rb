require "spec_helper"

xdescribe Zoom::Actions::User do
  let(:zc) { zoom_client }
  let(:args) {
    {email: "foo@bar.com",
     password: "somepassword123",
     first_name: "Zoomie",
     last_name: "Userton",
     type: 1}
  }
  let(:response) { zc.user_autocreate(args) }

  xdescribe "#user_autocreate action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/user/autocreate")
      ).to_return(body: json_response("user", "autocreate"))
    end

    it "requires email param" do
      expect { zc.user_autocreate(filter_key(args, :email)) }.to raise_error(ArgumentError)
    end

    it "requires type param" do
      expect { zc.user_autocreate(filter_key(args, :type)) }.to raise_error(ArgumentError)
    end

    it "requires password param" do
      expect { zc.user_autocreate(filter_key(args, :password)) }.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(response).to be_kind_of(Hash)
    end

    it "returns same params" do
      expect(response["email"]).to eq(args[:email])
      expect(response["first_name"]).to eq(args[:first_name])
      expect(response["last_name"]).to eq(args[:last_name])
      expect(response["type"]).to eq(args[:type])
    end
  end

  xdescribe "#user_autocreate! action" do
    before :each do
      stub_request(
        :post,
        zoom_url("/user/autocreate")
      ).to_return(body: json_response("error"))
    end

    it "raises Zoomus::Error exception" do
      expect {
        zc.user_autocreate!(args)
      }.to raise_error(Zoom::Error)
    end
  end
end
