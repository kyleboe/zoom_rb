# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Groups do
  let(:zc) { zoom_client }
  let(:args) { { group_id: 'g12345678',
                 members: [{ email: 'test@test.com', id: 'u12345678' }] } }

  describe '#group_member_create action' do
    context 'with a valid response' do
      before :each do
        stub_request(
          :post,
          zoom_url("/groups/#{args[:group_id]}/members")
        ).to_return(status: 201,
                    body: json_response('groups', 'member/add'),
                    headers: { 'Content-Type' => 'application/json' })
      end

      it "requires a 'group_id' argument" do
        expect { zc.group_member_create(filter_key(args, :group_id)) }.to raise_error(Zoom::ParameterMissing, [:group_id].to_s)
      end

      it "requires a 'members' argument" do
        modified_args = args.dup
        modified_args[:members] = nil
        expect { zc.group_member_create(modified_args) }.to raise_error(Zoom::ParameterMissing, [:members].to_s)
      end
      
      it 'returns a Hash' do
        expect(zc.group_member_create(args)).to be_kind_of(Hash)
      end

      it 'returns ids and added_at information' do
        res = zc.group_member_create(args)
        expect(res['ids']).to eq('u12345678')
        expect(res['added_at']).to eq('2025-03-17T16:14:24Z')
      end
    end

    context 'with a 4xx response' do
      context '404 not found' do
        before :each do
          stub_request(
            :post,
            zoom_url("/groups/#{args[:group_id]}/members")
          ).to_return(status: 404,
                      body: json_response('error', 'group_not_exist'),
                      headers: { 'Content-Type' => 'application/json' })
        end

        it 'raises Zoom::Error exception' do
          expect { zc.group_member_create(args) }.to raise_error(Zoom::Error)
        end
      end
    end
  end
end
