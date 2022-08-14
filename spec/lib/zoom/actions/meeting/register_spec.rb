# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Meeting do
  let(:zc) { zoom_client }
  let(:args) { { id: 1, email: 'foo@bar.com', first_name: 'Foo', last_name: 'Bar', meeting_id: 1 } }
  let(:bad_args) { { id: 1, email: 'foo@bar.com', bad_field_1: 'Foo', bad_field_2: 'Bar', meeting_id: 1 } }

  let(:batch_args) { {
      meeting_id: 1,
      registrants: [
        {
          id: 1, email: 'john.doe@bar.com', first_name: 'John', last_name: 'Doe'
        },
        {
          id: 2, email: 'jane.roe@baz.com', first_name: 'Jane', last_name: 'Roe'
        }
      ]
    }
  }

  describe '#meeting_register action' do
    it 'returns a hash' do
      expect(zc.meeting_register(args)).to be_kind_of(Hash)
    end

    it 'fails when the argument contents do not meet the expected contract' do
      args_copy = args.dup
      [:first_name, :last_name, :email].each do |field|
        args_copy.delete(field)
        expect { zc.meeting_register(args_copy) }.to raise_exception(Zoom::ParameterMissing)
      end
    end

    # Similar to the above test.  The expected fields per registrant are present, but nested in a batch format expected object.
    it 'fails when the correct registrant format is sent to the wrong method (batch data to non batch method)' do
      expect { zc.meeting_register(batch_args) }.to raise_exception(Zoom::ParameterMissing)
    end

  end

  describe '#batch_meeting_register action' do
    it 'returns a hash' do
      expect(zc.meeting_bulk_register(batch_args)).to be_kind_of(Hash)
    end

    it 'fails when the argument contents do not meet the expected contract' do
      batch_args_copy = batch_args.dup
      [:first_name, :last_name, :email].each do |field|
        batch_args_copy[:registrants].each do |registrant|
          registrant.delete(field)
        end
        expect { zc.meeting_bulk_register(batch_args_copy) }.to raise_exception(Zoom::ParameterMissing)
      end
    end

    # Similar to the above test.  The format is wrong, but the expected fields per registrant are present.
    it 'fails when the correct registrant format is sent to the wrong method (non-batch data to batch method)' do
      expect { zc.meeting_bulk_register(args) }.to raise_exception(Zoom::ParameterMissing)
    end

    it 'fails when the top level fields are missing' do
      batch_args_copy = batch_args.dup
      [:registrants, :meeting_id].each do |field|
        batch_args_copy.delete(field)
        expect { zc.meeting_bulk_register(batch_args_copy) }.to raise_exception(Zoom::ParameterMissing)
      end
    end
  end
end
