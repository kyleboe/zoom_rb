# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zoom::Params do

  describe '#require' do
    let(:params) { Zoom::Params.new(foo: :bar, baz: :bang) }

    it 'does not raise an error when required keys are present' do
      expect { params.require(:foo) }.not_to raise_error
    end

    it 'does raise an error when required keys are missing' do
      expect { params.require(:bar) }.to raise_error(Zoom::ParameterMissing, [:bar].to_s)
    end

    it 'returns the rest of the params' do
      expect(params.require(:foo)).to eql(baz: :bang)
    end
  end

  describe '#require_one_of' do
    let(:params) { Zoom::Params.new(foo: :bar, baz: :bang) }

    it 'does raise an error when required keys are missing' do
      expect { params.require_one_of(:bar) }.to raise_error(Zoom::ParameterMissing, [:bar].to_s)
    end

    it 'does raise an error when there is a missing required keys out of many' do
      expect { params.require_one_of(:bar, :fooey, :fooa) }.to raise_error(Zoom::ParameterMissing, "You are missing atleast one of #{[:bar, :fooey, :fooa].to_s}")
    end

    it 'does not raise an error when one of the required keys are missing' do
      expect { params.require_one_of(:foo) }.not_to raise_error
    end

    it 'does not raise an error when one of the required keys are missing' do
      expect { params.require_one_of(:foo, :bebop) }.not_to raise_error
    end
  end

  describe '#permit' do
    let(:params) { Zoom::Params.new(foo: true, bar: :baz ) }

    it 'does not raise an error when permitted keys are present' do
      expect { params.require(:foo).permit(:bar) }.not_to raise_error
    end

    it 'does not raise an error when permitted keys are not present' do
      expect { params.require(:foo).permit(:bar, :bang) }.not_to raise_error
    end

    context 'raises an error' do
      let(:bad_params) { Zoom::Params.new(foo: true, bar: :baz, bang: :boom) }
      let(:other_bad_params) do
        Zoom::Params.new(foo: true, bar: { baz: :bang,
                                           boom: :pow,
                                           asdf: :test,
                                           testerino: :other })
      end
      let(:really_bad_params) do
        Zoom::Params.new(foo: true,
                         bar: {
                           baz: {
                             bang: {
                               nested: true,
                               this: :thing,
                               is: { very: :deep },
                               bad_param: :asdf
                             }
                           }
                         })
      end
      it 'when non-permitted keys are present' do
        expect { bad_params.require(:foo).permit(:bar) }.to raise_error(Zoom::ParameterNotPermitted, [:bang].to_s)
      end

      it 'when nested non-permitted keys are present' do
        expect { other_bad_params.require(:foo).permit(bar: [:baz, :boom]) }.to raise_error(Zoom::ParameterNotPermitted, [:asdf, :testerino].to_s)
      end

      it 'when deeply nested non-permitted keys are present' do
        expect { really_bad_params.require(:foo).permit(bar: { baz: { bang: [ :nested, :this, { is: :very } ] } }) }.to raise_error(Zoom::ParameterNotPermitted, [:bad_param].to_s)
      end
    end
  end

  describe '#permit_value' do
    let(:params) { Zoom::Params.new(foo: :bar, baz: :bang) }
    let(:values) { %i(bar baz) }

    it 'does not raise an error when required value are present in values' do
      expect { params.permit_value(:foo, values) }.not_to raise_error
    end

    it 'does raise an error when required keys are missing' do
      expect { params.permit_value(:baz, values) }.to raise_error(Zoom::ParameterValueNotPermitted, "#{:baz.to_s}: #{:bang.to_s}")
    end
  end

  describe '#parameters_keys' do
    context 'when param is array ' do
      let(:params) { Zoom::Params.new([{foo: :bar, baz: :bang}, {foo: :bar1, baz: :bang1}]) }
  
      it 'get each object keys and return unique of them' do
        expect(params.parameters_keys).to eq([:foo, :baz])
      end
    end
    
    context 'when param is Hash ' do
      let(:params) { Zoom::Params.new({foo: :bar, baz: :bang}) }
  
      it 'return hash keys' do
        expect(params.parameters_keys).to eq([:foo, :baz])
      end
    end
  end
end
