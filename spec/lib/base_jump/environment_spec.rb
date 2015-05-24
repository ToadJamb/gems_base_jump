require 'spec_helper'

RSpec.describe BaseJump::Environment do
  describe '.env' do
    subject { klass.env }

    let(:klass) { Module.new.extend described_class }

    it "returns the #{BaseJump::Env} module" do
      expect(subject).to eq BaseJump::Env
    end
  end
end
