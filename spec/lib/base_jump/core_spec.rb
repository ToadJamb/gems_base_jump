require 'spec_helper'

RSpec.describe BaseJump do
  describe '.load_environment' do
    subject { described_class::Env }

    let(:klass) { Module.new { extend self } }
    let(:glob)  { 'config/environments/*.rb' }

    let(:envs) {[
      'config/environments/test.rb',
      'config/environments/development.rb',
      'config/environments/production.rb',
      'config/environments/foobar.rb',
    ]}

    before { mock_system(:dir_glob).with(glob).and_return envs }

    before { stub_const "#{described_class::Env}", klass }
    before { described_class.load_environment }

    it 'creates boolean methods based on environment files' do
      expect(subject).to respond_to :test?
      expect(subject).to respond_to :development?
      expect(subject).to respond_to :production?
      expect(subject).to respond_to :foobar?

      expect(subject).to_not respond_to :foo?
    end
  end

  describe '.environment? methods' do
    let(:klass) { Module.new { extend self } }

    before { stub_const "#{described_class::Env}", klass }
    before { mock_system(:dir_glob).and_return envs }

    before { described_class.load_environment }

    shared_examples 'a dynamic method' do |method, actual|
      subject { described_class::Env }

      context "given the environment is #{actual}" do
        let(:method_name)   { "#{method}?" }
        let(:actual_method) { "#{actual}?" }
        let(:expected)      { method == actual }

        let(:envs) do
          [method, actual].uniq.map do |env|
            "config/environments/#{env}.rb"
          end.push("config/environments/foo.rb").shuffle
        end

        before do
          allow(BaseJump::Environment)
            .to receive(:environment)
            .and_return actual.to_s
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
