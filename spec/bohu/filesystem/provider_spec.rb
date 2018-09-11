# frozen_string_literal: true

# class methods
describe Bohu::Filesystem::Provider, :'filesystem/provider' do
  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

describe Bohu::Filesystem::Provider, :'filesystem/provider' do
  it { expect(subject).to be_a(Bohu::Delegator) }
  it { expect(subject).to be_a(Bohu::Configurable) }
end

# FileUtils methods
describe Bohu::Filesystem::Provider, :'filesystem/provider' do
  let(:config) { { filesystem: { verbose: false } } }
  let(:subject) { described_class.new(config) }

  sham!(:filesystem).im.each do |method|
    it { expect(subject).to respond_to(method) }
  end
end
