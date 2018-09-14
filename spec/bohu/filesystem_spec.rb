# frozen_string_literal: true

# class methods
describe Bohu::Filesystem, :filesystem do
  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

# instance methods
describe Bohu::Filesystem, :filesystem do
  let(:config) { {} }
  let(:subject) { described_class.new(config) }

  # FileUtils methods
  sham!(:filesystem).im.each do |method|
    it { expect(subject).to respond_to(method) }
  end

  it { expect(subject).to respond_to(:verbose?).with(0).arguments }

  context '#verbose?' do
    it { expect(subject.verbose?).to be(true) }
  end

  context '#verbose?' do
    let(:config) { { filesystem: { verbose: false } } }

    it { expect(subject.verbose?).to be(false) }
  end

  context '#verbose?' do
    let(:config) { { filesystem: { verbose: true } } }

    it { expect(subject.verbose?).to be(true) }
  end
end
