# frozen_string_literal: true

# class methods
describe Bohu::Shell::Provider, :'shell/provider' do
  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

describe Bohu::Shell::Provider, :'shell/provider' do
  it { expect(subject).to be_a(Bohu::Delegator) }
  it { expect(subject).to be_a(Bohu::Configurable) }
end

# instance methods
describe Bohu::Shell::Provider, :'shell/provider' do
  let(:config) { { shell: { verbose: false } } }
  let(:subject) { described_class.new(config) }

  sham!(:shell).im.each do |method|
    it { expect(subject).to respond_to(method).with_unlimited_arguments }
  end
end
