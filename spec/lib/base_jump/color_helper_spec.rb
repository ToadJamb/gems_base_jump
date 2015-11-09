require 'spec_helper'

RSpec.describe BaseJump::ColorHelper do
  let(:text)  { 'foo bar baz' }
  let(:color) { :blue }

  before { require 'colorize' }
  before { String.disable_colorization = false }

  describe '.colorize' do
    subject { described_class.colorize text, color }

    let(:config) { instance_double BaseJump::Configuration }

    before { allow(BaseJump::Backpack).to receive(:configuration).and_return config }

    context 'given colorize is defined' do
      before { allow(config).to receive(:colorize?).and_return true }

      it 'returns the colorized string' do
        expect(subject).to match(/\e\[\d;\d{1,2};\d{1,2}m#{text}.*\e\[\dm/)
      end

      context 'given a symbol' do
        let(:text) { :text }
        it 'returns the symbol as a colorized string' do
          expect(subject).to match(/\e\[\d;\d{1,2};\d{1,2}m#{text}.*\e\[\dm/)
        end
      end
    end

    context 'given colorize is not defined' do
      before { allow(config).to receive(:colorize?).and_return false }

      it 'returns the string' do
        expect(subject).to eq text
      end

      context 'given a symbol' do
        let(:text) { :text }

        it 'returns the symbol' do
          expect(subject).to eq text
        end
      end
    end
  end

  describe '.next_color' do
    let(:colors) {[
      :red,
      :green,
      :blue,
      :yellow,
      :cyan,
    ][0..(rand(5) + 1)]}

    before { stub_const 'BaseJump::ColorHelper::COLORS', colors }

    before { @index = described_class.send(:index) }
    before { described_class.instance_variable_set :@index, nil }

    after  { described_class.send :index=, @index }

    it 'cycles through the colors' do
      (3 * colors.count).times do |i|
        index = i % colors.count
        expect(described_class.next_color).to eq colors[index]
      end
    end
  end

  describe '.colored?' do
    subject { described_class.colored? text }

    context 'given text that is partly colored' do
      let(:text) { "foo #{'bar'.colorize(color)} baz" }

      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'given text that is not colored' do
      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context 'given a symbol' do
      let(:text) { :text }

      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end
end
