require 'spec_helper'

RSpec.describe BaseJump::Application do
  describe '.init' do
    subject { BaseJump::Config.app }

    let(:klass)         { Module.new { extend self } }
    let(:app_namespace) { Module.new }

    let(:envs) {[
      'config/environments/test.rb',
      'config/environments/development.rb',
      'config/environments/production.rb',
    ]}

    before { mock_system(:dir_glob).and_return envs }
    before { stub_const "#{BaseJump::Env}", klass }

    before { BaseJump::Config.app = nil }

    before { described_class.init app_namespace }

    it 'sets the application namespace' do
      expect(subject).to eq app_namespace
    end

    it 'adds environment methods' do
      expect(subject.env).to respond_to :test?
      expect(subject.env).to respond_to :development?
      expect(subject.env).to respond_to :production?
    end

    context 'given the application has been set' do
      it 'raises an error' do
        expect{described_class.init(app_namespace)}
          .to raise_error BaseJump::ApplicationInitializedError
      end
    end
  end
end
