# frozen_string_literal: true

# class methods
describe Bohu::Utils, :utils do
  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

# instance methods
describe Bohu::Utils, :utils do
  let(:config) { { utils: { verbose: false } } }
  let(:subject) { described_class.new(config) }

  it { expect(subject).to respond_to(:verbose?).with(0).arguments }
  it { expect(subject).to respond_to(:sh).with_unlimited_arguments }
end

# FileUtils methods
describe Bohu::Utils, :utils do
  let(:config) { { utils: { verbose: false } } }
  let(:subject) { described_class.new(config) }

  sham!(:utils).im.each do |method|
    it { expect(subject).to respond_to(method) }
  end
end
