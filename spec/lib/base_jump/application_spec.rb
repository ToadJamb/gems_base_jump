require 'spec_helper'

RSpec.describe BaseJump::Application do
  describe '.configure' do
    context 'given a block' do
      it "yields #{BaseJump::Backpack}" do
        described_class.configure do |config|
          expect(config).to eq BaseJump::Backpack
        end
      end
    end

    context 'given no block' do
      it 'works' do
        described_class.configure
      end
    end
  end
end
