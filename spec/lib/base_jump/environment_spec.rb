require 'spec_helper'

RSpec.describe BaseJump::Environment do
  subject { instance }

  let(:klass)    { Class.new { include BaseJump::Environment } }
  let(:instance) { klass.new }

  describe '.env' do
    subject { instance.env }

    it "returns the #{BaseJump::Env} module" do
      expect(subject).to eq BaseJump::Env
    end
  end

  describe '.environment=' do
    let(:env_var) { 'FOO_ENV' }
    before { stub_const 'ENV', {} }

    before do
      allow(BaseJump::Backpack)
        .to receive(:env_var)
        .and_return env_var
    end

    shared_examples 'an environment setter' do |input, output|
      subject { instance.environment }

      context "given #{input.inspect}" do
        before { instance.environment = input }

        it "returns #{output.inspect}" do
          expect(subject).to eq output
        end

        it "sets the environment variable to #{output.to_s.inspect}" do
          expect(ENV[BaseJump::Backpack.env_var]).to eq output.to_s
        end
      end
    end

    it_behaves_like 'an environment setter', nil, :development
    it_behaves_like 'an environment setter', " \t\n  ", :development

    it_behaves_like 'an environment setter', 'foo', :foo
    it_behaves_like 'an environment setter', :foo, :foo
    it_behaves_like 'an environment setter', 'FoO', :foo
    it_behaves_like 'an environment setter', " \tfoo ", :foo
  end
end
