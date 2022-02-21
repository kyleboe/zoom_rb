# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { { webinar_id: '123456789' } }

  describe '#webinar_panelist_list' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/panelists")
        ).to_return(status: 200,
                    body: json_response('webinar', 'panelist_list'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'id' argument" do
        expect { zc.webinar_panelist_list(filter_key(args, :webinar_id)) }.to raise_error(Zoom::ParameterMissing, [:webinar_id].to_s)
      end

      it 'returns a list of panelists as an array' do
        expect(zc.webinar_panelist_list(args)['panelists']).to be_kind_of(Array)
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :get,
          zoom_url("/webinars/#{args[:webinar_id]}/panelists")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.webinar_panelist_list(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end