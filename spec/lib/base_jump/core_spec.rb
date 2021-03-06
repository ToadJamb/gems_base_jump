require 'spec_helper'

RSpec.describe BaseJump do
  let(:app_namespace) { Module.new }

  before { described_class::Backpack.instance_variable_set :@app, nil }

  describe '.init' do
    subject { BaseJump::Backpack.app }

    let(:klass) { Module.new { extend self } }
    let(:env)   { described_class::Env }
    let(:glob)  { 'config/environments/*.rb' }

    let(:envs) {[
      'config/environments/test.rb',
      'config/environments/development.rb',
      'config/environments/production.rb',
      'config/environments/foobar.rb',
    ]}

    before { mock_system(:dir_glob).and_return envs }
    before { stub_const "#{described_class::Env}", klass }

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

    it 'creates boolean methods based on environment files' do
      expect(env).to respond_to :test?
      expect(env).to respond_to :development?
      expect(env).to respond_to :production?
      expect(env).to respond_to :foobar?

      expect(env).to_not respond_to :foo?
    end

    it "extends #{described_class::Application}" do
      mod = described_class::Application
      methods = mod.methods - mod.class.methods

      methods.each do |method|
        expect(subject).to respond_to method
      end
    end
  end

  describe '.environment? methods' do
    let(:klass) { Module.new { extend self } }

    before { mock_system(:dir_glob).and_return envs }

    before { described_class.init app_namespace }

    shared_examples 'a dynamic method' do |method, actual|
      subject { BaseJump::Backpack.app.env }

      context "given the environment is #{actual}" do
        let(:method_name)   { "#{method}?" }
        let(:actual_method) { "#{actual}?" }
        let(:expected)      { method == actual }

        let(:envs) do
          [method, actual].uniq.map do |env|
            "config/environments/#{env}.rb"
          end.push("config/environments/foo.rb").shuffle
        end

        let(:app) do
          Module.new do
            extend BaseJump::Application
          end
        end

        before do
          allow(BaseJump::Backpack)
            .to receive(:app)
            .and_return app

          allow(BaseJump::Backpack.app)
            .to receive(:environment)
            .and_return actual
        end

        describe ".#{method}?" do
          it "returns #{method == actual}" do
            expect(subject.send(method_name)).to eq expected
          end
        end

        describe '.foo?' do
          it 'returns false' do
            expect(subject.foo?).to eq false
          end
        end

        unless method == actual
          describe ".#{actual}?" do
            it 'returns true' do
              expect(subject.send(actual_method)).to eq true
            end
          end
        end
      end
    end

    it_behaves_like 'a dynamic method', :development, :development
    it_behaves_like 'a dynamic method', :development, :test
  end
end
