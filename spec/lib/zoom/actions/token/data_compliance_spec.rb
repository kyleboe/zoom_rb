# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Token do
  let(:zc) { oauth_client }
  let(:args) do
    {
      client_id: "df22ff22ifjiedfsk",
      user_id: "ffww554884fwe21fe",
      account_id: "fwefkjKfjwe9e",
      deauthorization_event_received: {
        user_data_retention: false,
        account_id: "fwefkjKfjwe9e",
        user_id: "a8yBxjayaSiw02igC8p8l0",
        signature: "85f9dd5684aecfa97h7bc86b7edc345204467f2jfj4df1b290093cf73fd1e6b00",
        deauthorization_time: "2019-06-17T13:52:28.632Z",
        client_id: "df22ff22ifjiedfsk"
      },
      compliance_completed: true
    }
  end

  describe '#data_compliance action' do
    before :each do
      Zoom.configure do |config|
        config.api_key = 'xxx'
        config.api_secret = 'xxx'
      end

      stub_request(
        :post,
        zoom_auth_url('oauth/data/compliance')
      ).to_return(body: json_response('token', 'data_compliance'),
                    headers: { 'Content-Type' => 'application/json' })
    end

    it "raises an error when args missing" do
      expect { zc.data_compliance }.to raise_error(Zoom::ParameterMissing, [:client_id, :user_id, :account_id, :deauthorization_event_received, :compliance_completed].to_s)
    end

    it 'returns a hash' do
      expect(zc.data_compliance(args)).to be_kind_of(Hash)
    end
  end
end
