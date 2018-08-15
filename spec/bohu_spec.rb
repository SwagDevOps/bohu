# frozen_string_literal: true

describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }

  it { expect(described_class).to be_const_defined(:VERSION) }
  it { expect(described_class).to be_const_defined(:Config) }
  it { expect(described_class).to be_const_defined(:DotHash) }
end

describe Bohu, :bohu do
  let(:described_class) { Class.new { include Bohu } }

  it { expect(subject).to respond_to(:config).with(0).arguments }
end
