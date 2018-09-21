# frozen_string_literal: true

# class methods
describe Bohu::Command, :command do
  it { expect(described_class).to respond_to(:new).with(2).arguments }
  it { expect(described_class).to respond_to(:new).with(3).arguments }
end

# const
describe Bohu::Command, :command do
  it { expect(described_class).to be_const_defined(:Runner) }
  it { expect(described_class).to be_const_defined(:Dialect) }
end

# instance methods
describe Bohu::Command, :command do
  let(:config) do
    {
      commands: {
        foo: {
          actions: {
            bar: {
              param: '%<param>s'
            }
          }

        }
      }
    }
  end
  let(:subject) { described_class.new(:foo, :bar, config) }

  it { expect(subject).to be_a(Array) }
  it { expect(subject).to be_a(Bohu::Configurable) }

  it { expect(subject).to respond_to(:name).with(0).arguments }
  it { expect(subject).to respond_to(:action).with(0).arguments }
  it { expect(subject).to respond_to(:executable).with(0).arguments }
  it { expect(subject).to respond_to(:executable?).with(0).arguments }
  it { expect(subject).to respond_to(:prepare).with(0).arguments }
  it { expect(subject).to respond_to(:prepare).with(1).arguments }
  it { expect(subject).to respond_to(:preparable?).with(0).arguments }
  it { expect(subject).to respond_to(:call).with(0).arguments }
  it { expect(subject).to respond_to(:call).with(1).arguments }
end
