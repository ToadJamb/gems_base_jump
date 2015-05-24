require 'spec_helper'

RSpec.describe BaseJump::Application do
  describe '.init' do
    let(:app_namespace) { 'application-namespace' }

    before { described_class.instance_variable_set :@app, nil }
    before { described_class.remove_instance_variable :@app }
    before { described_class.init app_namespace }

    it 'sets the application namespace' do
      expect(described_class.app).to eq app_namespace
    end

    context 'given the application has been set' do
      it 'raises an error' do
        expect{described_class.init(app_namespace)}
          .to raise_error BaseJump::ApplicationInitializedError
      end
    end
  end
end
