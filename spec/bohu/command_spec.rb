# frozen_string_literal: true

# class methods
describe Bohu::Command, :command do
  it { expect(described_class).to respond_to(:new).with(2).arguments }
  it { expect(described_class).to respond_to(:new).with(3).arguments }
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
end
