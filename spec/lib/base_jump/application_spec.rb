require 'spec_helper'

RSpec.describe BaseJump::Application do
  subject { app }

  let(:app) { Module.new { extend BaseJump::Application } }

  before { allow(BaseJump::Backpack).to receive(:env_var).and_return 'MY_ENV' }

  context 'environment' do
    it 'is included' do
      app.environment = nil
      expect(app.environment).to eq :development
    end
  end

  describe '.configure' do
    context 'given a block' do
      it "yields #{BaseJump::Backpack}" do
        app.configure do |conf|
          expect(conf).to be_a BaseJump::Configuration
          expect(conf).to eq BaseJump::Backpack.configuration
        end
      end
    end

    context 'given no block' do
      it 'works' do
        app.configure
      end
    end
  end
end
