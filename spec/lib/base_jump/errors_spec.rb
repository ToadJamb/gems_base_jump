require 'spec_helper'

RSpec.describe BaseJump do
  describe BaseJump::ApplicationInitializedError do
    describe '.message' do
      subject { raise described_class.new(app_namespace) }

      let(:app_namespace) { 'application-namespace' }

      it 'indicates what namespace the app was initialized with' do
        expect{subject}.to raise_error(/already initialized/)
        expect{subject}.to raise_error(/#{app_namespace}/)
      end
    end
  end
end
