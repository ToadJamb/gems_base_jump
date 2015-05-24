require 'spec_helper'

RSpec.describe BaseJump::Application do
  describe '.set' do
    let(:namespace) { 'application-namespace' }

    before { described_class.set namespace }

    it 'sets the application namespace' do
      expect(described_class.app).to eq namespace
    end
  end
end
