# frozen_string_literal: true

require 'bohu/config_base'

describe Bohu::ConfigBase, :config, :config_base do
  it { expect(subject).to be_a(Hash) }
  it { expect(subject).to be_a(Bohu::DotHash) }

  it { expect(subject).to respond_to(:deep_merge).with(1).arguments }
  it { expect(subject).to respond_to(:deep_merge!).with(1).arguments }
end

describe Bohu::ConfigBase, :config, :config_base do
  let(:origin) { { 'size' => { height: 100, width: 500 }, 'color' => 'red' } }
  let(:data) { { size: { height: 50, width: 250 }, 'desc' => 'description' } }
  let(:expected) do
    { size: { height: 50, width: 250 }, color: 'red', desc: 'description' }
  end

  context '#deep_merge' do
    let(:subject) { described_class.new(origin).deep_merge(data) }
    let(:object_id) { subject.object_id }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).to eq(expected) }
    it { expect(subject).not_to eq(object_id) }
  end

  context '#deep_merge!' do
    let(:subject) { described_class.new(origin).deep_merge!(data) }
    let(:object_id) { subject.object_id }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).to eq(expected) }
    it { expect(subject.object_id).to eq(object_id) }
  end
end
