# frozen_string_literal: true

require 'bohu/command'

# class methods
describe Bohu::Command::Dialect, :'command/dialect' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }

  it { expect(described_class).to respond_to(:load).with(2).arguments }
  it { expect(described_class).to respond_to(:load).with(3).arguments }

  it { expect(described_class).to respond_to(:paths).with(0).arguments }
  it { expect(described_class).to respond_to(:paths).with(1).arguments }

  it { expect(described_class).to respond_to(:file).with(1).arguments }

  it { expect(described_class).to respond_to(:default_path).with(0).arguments }
end

# class methods - paths
describe Bohu::Command::Dialect, :'command/dialect' do
  context '.paths' do
    it { expect(described_class.paths).to be_a(Array) }
  end

  context '.paths.size' do
    it { expect(described_class.paths.size).to eq(1) }
  end

  context '.paths.map' do
    it { expect(described_class.paths.map(&:class)).to eq([Pathname]) }
  end

  context '.paths.first.directory?' do
    it { expect(described_class.paths.first.directory?).to be(true) }
  end
end

# instance
describe Bohu::Command::Dialect, :'command/dialect' do
  let(:subject) { described_class.new({}) }

  it { expect(subject).to be_a(Hash) }
  it { expect(subject).to respond_to(:transform).with(1).arguments }
end

# instance - using ``default/lorem``
describe Bohu::Command::Dialect, :'command/dialect', :wip do
  let(:samples) { sham!('command/dialect').samples }
  let(:subject) { described_class.file(samples.fetch('default/lorem')) }
  let(:parsed) { { count: ['-n', '%<count>s'] } }

  it { expect(subject).to be_a(Hash) }
  it { expect(subject).to be_a(described_class) }
  it { expect(subject).to eq(parsed) }

  context '#transform' do
    let(:input) { { count: 4 } }
    let(:transformed) { ['-n', '4'] }

    it { expect(subject.transform(input)).to eq(transformed) }
  end

  context '#transform' do
    let(:input) { { count: 4, foo: 'bar', answer: 42 } }
    let(:transformed) { ['-n', '4', 'bar', '42'] }

    it { expect(subject.transform(input)).to eq(transformed) }
  end
end
