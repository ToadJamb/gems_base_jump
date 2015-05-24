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
end
