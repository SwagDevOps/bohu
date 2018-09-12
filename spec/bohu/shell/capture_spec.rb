# frozen_string_literal: true

describe Bohu::Shell::Capture, :'shell/capture' do
  it { expect(subject).to be_a(Array) }

  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

# instance methods
describe Bohu::Shell::Capture, :'shell/capture' do
  let(:subject) { described_class.new(['lorem']) }

  [:capture, :capture!].each do |method|
    it { expect(subject).to respond_to(method).with(0).arguments }

    context "##{method}" do
      it { expect(subject.public_send(method)).to be_a(Bohu::Shell::Result) }
    end

    context "##{method}.status" do
      it do
        expect(subject.public_send(method).status).to be_a(Process::Status)
      end
    end

    context "##{method}.stdout" do
      let(:matcher) { /^Lorem ipsum dolor sit amet/ }

      it { expect(subject.public_send(method).stdout).to be_a(String) }
      it { expect(subject.public_send(method).stdout).to match(matcher) }
    end

    context "##{method}.stderr" do
      it { expect(subject.public_send(method).stderr).to be_a(String) }
      it { expect(subject.public_send(method).stderr).to eq('') }
    end
  end
end

# instance methods - capture (failure)
describe Bohu::Shell::Capture, :'shell/capture' do
  let(:subject) { described_class.new(['false']) }

  context '#capture!' do
    it do
      expect { subject.capture! }
        .to raise_error(Bohu::Shell::ExitStatusError)

      expect { subject.capture! }
        .to raise_error('"false" exited with status: 1')
    end
  end
end
