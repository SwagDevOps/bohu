# frozen_string_literal: true

describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }

  it { expect(described_class).to be_const_defined(:VERSION) }
  it { expect(described_class).to be_const_defined(:Config) }
  it { expect(described_class).to be_const_defined(:Configurable) }
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Commands) }
  it { expect(described_class).to be_const_defined(:DotHash) }
  it { expect(described_class).to be_const_defined(:Etc) }
  it { expect(described_class).to be_const_defined(:Shell) }
  it { expect(described_class).to be_const_defined(:Utils) }
  it { expect(described_class).to be_const_defined(:Which) }
end

describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }

  it { expect(subject).to respond_to(:config).with(0).arguments }
  it { expect(subject).to respond_to(:config_load).with(0).arguments }
end

describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }
  # Using no config (no defaults, and no filepath given)
  let(:subject) do
    described_class.new.tap do |instance|
      instance.config_load(load_defaults: false)
    end
  end

  it { expect(subject).to respond_to(:sh).with_unlimited_arguments }

  # FileUtils methods
  sham!(:utils).im.each do |method|
    it { expect(subject).to respond_to(method) }
  end
end
