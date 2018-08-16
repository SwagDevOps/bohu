# frozen_string_literal: true

# class methods
describe Bohu::Config, :config do
  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }

  it { expect(described_class).to respond_to(:defaults).with(0).arguments }

  context '.defaults' do
    it { expect(described_class.defaults).to be_a(Hash) }
  end

  context '.safe_load' do
    let(:sample) { sham!(:configs).samples.fetch('empty') }
    let(:parsed) { described_class.__send__(:safe_load, sample) }

    it { expect(parsed).to be_a(Hash) }
    it { expect(parsed).to be_empty }
  end
end

# instance inheritance + methods
describe Bohu::Config, :config do
  it { expect(subject).to be_a(Hash) }
  it { expect(subject).to be_a(Bohu::DotHash) }
  it { expect(subject).to be_a(Bohu::ConfigBase) }
end
