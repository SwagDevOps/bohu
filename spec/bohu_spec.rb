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
  it { expect(described_class).to be_const_defined(:Filesystem) }
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
  sham!(:filesystem).im.each do |method|
    it { expect(subject).to respond_to(method) }
  end
end

# protected methods - callables
describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }
  let(:callables) { subject.__send__(:callables) }
  let(:mapped) do
    [Bohu::Shell::Provider, Bohu::Commands::Shell,
     Bohu::Etc, Bohu::Filesystem::Provider]
  end
  let(:subject) do
    described_class.new.tap do |instance|
      instance.config_load(load_defaults: false)
    end
  end

  context '#callables' do
    it { expect(callables).to be_a(Array) }
  end

  context '#callables.size' do
    it { expect(callables.size).to be(mapped.size) }
  end

  context '#callables.map' do
    let(:mapped) { [Proc] * callables.size }

    it { expect(callables.map(&:class)).to eq(mapped) }
  end

  context '#callables.map' do
    it { expect(callables.map { |c| c.call.class }).to eq(mapped) }
  end
end

# protected methods - instance_for
describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }
  let(:subject) do
    described_class.new.tap do |instance|
      instance.config_load(load_defaults: false)
    end
  end

  context '#instance_for' do
    sham!(:filesystem).im.each do |method|
      it method.inspect do
        subject.__send__(:instance_for, method).tap do |instance|
          expect(instance).to be_a(Bohu::Filesystem::Provider)
        end
      end
    end
  end
end
