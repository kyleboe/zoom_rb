# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { { webinar_id: '123456789' } }

  describe '#webinar_panelists_delete_all' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :delete,
          zoom_url("/webinars/#{args[:webinar_id]}/panelists")
        ).to_return(status: 204,
                    body: json_response('webinar', 'panelist_delete_all'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'webinar id' argument" do
        expect { zc.webinar_panelists_delete_all(filter_key(args, :webinar_id)) }.to raise_error(Zoom::ParameterMissing, [:webinar_id].to_s)
      end

      it 'returns the http status code as a number' do
        expect(zc.webinar_panelists_delete_all(args)).to eql(204)
      end

    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :delete,
          zoom_url("/webinars/#{args[:webinar_id]}/panelists")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.webinar_panelist_delete(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end