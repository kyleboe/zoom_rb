# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zoom::Error do
  let(:rescue?) { false }

  subject do
    begin
      raise Zoom::ParameterMissing, "msg"
    rescue Zoom::Error => error
      if rescue?
        true
      else
        raise error
      end
    end
  end

  it 'raises specific errors' do
    expect { subject }.to raise_error(Zoom::ParameterMissing, "msg")
  end

  context 'with errors rescued' do
    let(:rescue?) { true }

    it 'descends from Zoom::Error' do
      expect(subject).to be true
    end
  end
end
