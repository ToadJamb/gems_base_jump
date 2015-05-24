require 'spec_helper'

RSpec.describe BaseJump::Config do
  subject { described_class }

  describe '.init' do
    let(:app) { Module.new }

    before { subject.init app }

    it 'sets the app' do
      expect(subject.app).to eq app
    end
  end
end
