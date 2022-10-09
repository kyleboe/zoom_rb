# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Webinar do
  let(:zc) { zoom_client }
  let(:args) { { webinar_id: '123456789',
                 panelists: [{email: "foo@bar.com", name: "Foo Bar"}] } }

  describe '#webinar_panelist_add' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/webinars/#{args[:webinar_id]}/panelists")
        ).to_return(status: 201,
                    body: json_response('webinar', 'panelist_add'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'webinar id' argument" do
        expect { zc.webinar_panelist_add(filter_key(args, :webinar_id)) }.to raise_error(Zoom::ParameterMissing, [:webinar_id].to_s)
      end

      it "requires a 'panelists' argument" do
        expect { zc.webinar_panelist_add(filter_key(args, :panelists)) }.to raise_error(Zoom::ParameterMissing, [:panelists].to_s)
      end
      
      it 'returns an Hash' do
        expect(zc.webinar_panelist_add(args)).to be_kind_of(Hash)
      end

      it 'returns an "id"' do
        res = zc.webinar_panelist_add(args)
        expect(res['id']).not_to be nil
      end
    end

    context 'with a 4xx response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/webinars/#{args[:webinar_id]}/panelists")
        ).to_return(status: 404,
                    body: json_response('error', 'validation'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Zoom::Error exception' do
        expect { zc.webinar_panelist_add(args) }.to raise_error(Zoom::Error)
      end
    end
  end
end