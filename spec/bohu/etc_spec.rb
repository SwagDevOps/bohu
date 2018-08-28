# frozen_string_literal: true

# class methods
describe Bohu::Etc, :etc do
  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

# instance methods
describe Bohu::Etc, :etc do
  it { expect(subject).to respond_to(:groups).with(0).arguments }
  it { expect(subject).to respond_to(:passwd).with(0).arguments }
  it { expect(subject).to respond_to(:uname).with(0).arguments }
end

describe Bohu::Etc, :etc do
  it { expect(subject).to be_a(Bohu::Configurable) }

  context '#groups' do
    it { expect(subject.groups).to be_a(Hash) }
  end

  context '#passwd' do
    it { expect(subject.passwd).to be_a(Hash) }
  end

  context '#uname' do
    it { expect(subject.uname).to be_a(Hash) }
  end
end
