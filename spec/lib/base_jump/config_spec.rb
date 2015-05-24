require 'spec_helper'

RSpec.describe BaseJump::Config do
  subject { described_class }

  let(:app_name) { 'Foo::Bar' }

  let(:app) { Module.new { extend self } }

  before { allow(app).to receive(:to_s).and_return app_name }

  describe '.init' do
    let(:environment) { :foobar }

    context 'by default' do
      before { subject.init app }

      it 'sets the app' do
        expect(subject.app).to eq app
      end
    end

    context 'given an environment variable matching the root namespace' do
      before { stub_const 'ENV', {'FOO_ENV' => environment.to_s } }

      before { subject.init app }

      it 'sets the environment to that value' do
        expect(BaseJump::Environment.environment).to eq environment.to_sym
      end
    end

    context 'given no environment variable matching the root namespace' do
      before { subject.init app }
      it 'sets the environment to development' do
        expect(BaseJump::Environment.environment).to eq :development
      end
    end
  end

  context '.env_var' do
    shared_examples 'the name of the environment variable' do |name, env_var|
      subject { described_class.env_var }

      context "given the name of the app is #{name}" do
        let(:app_name) { name }

        before { described_class.init app }

        it "returns #{env_var}" do
          expect(subject).to eq env_var
        end
      end
    end

    it_behaves_like 'the name of the environment variable', 'Ab::B', 'AB_ENV'
    it_behaves_like 'the name of the environment variable', 'Ab', 'AB_ENV'
  end
end
