require 'spec_helper'

RSpec.describe BaseJump::Application do
  subject { app }

  let(:app) { Module.new { extend BaseJump::Application } }

  before { BaseJump::Backpack.init app }

  context 'environment' do
    it 'is included' do
      app.environment = nil
      expect(app.environment).to eq :development
    end
  end

  describe '.configure' do
    context 'given a block' do
      it "yields #{BaseJump::Backpack}.configuration" do
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

  describe '.logger' do
    subject { app.logger }

    let(:config) { BaseJump::Configuration.new }
    let(:logger) { 'current-logger' }

    before do
      allow(BaseJump::Backpack).to receive(:configuration).and_return config
      allow(config).to receive(:logger).and_return logger
    end

    it "returns the #{BaseJump::Backpack} logger" do
      expect(subject).to eq logger
    end
  end
end
