# frozen_string_literal: true

require 'bohu/command'

# class methods
describe Bohu::Command::Runner, :'command/runner' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
  it { expect(described_class).to respond_to(:new).with(2).arguments }
end

# instance
describe Bohu::Command::Runner, :'command/runner' do
  let(:subject) { described_class.new(['true'], shell: {}) }

  it { expect(subject).to be_a(Array) }
  it { expect(subject).to eq(['true']) }
  it { expect(subject).to respond_to(:config).with(0).arguments }
end

# testing output
describe Bohu::Command::Runner, :'command/runner' do
  let(:subject) { described_class.new(['true'], config) }

  context '#call' do
    let(:config) { { shell: {} } }

    specify do
      silence_stream($stderr) do
        expect { subject.call }.to output(/true$/).to_stderr
        expect { subject.call }.to_not output.to_stdout
      end
    end
  end

  context '#call' do
    let(:config) { { shell: { verbose: false } } }

    specify do
      silence_stream($stderr) do
        expect { subject.call }.to_not output.to_stderr
        expect { subject.call }.to_not output.to_stdout
      end
    end
  end
end

describe Bohu::Command::Runner, :'command/runner' do
  let(:subject) { described_class.new(command, shell: {}) }

  # command with arguments
  context '#call' do
    let(:command) { ['true', '42', 'foo', 'bar'] }

    specify do
      silence_stream($stderr) do
        expect { subject.call }.to output(/true 42 foo bar$/).to_stderr
      end
    end
  end

  # command with arguments (shell escape)
  context '#call' do
    let(:command) { ['true', '42', 'foo bar'] }

    specify do
      silence_stream($stderr) do
        expect { subject.call }.to output(/true 42 foo\\ bar$/).to_stderr
      end
    end
  end
end

# testing execptions
describe Bohu::Command::Runner, :'command/runner' do
  let(:subject) { described_class.new(command, shell: {}) }
  let(:command) { ['false'] } # exit 1

  context '#call' do
    it do
      silence_stream($stderr) do
        expect { subject.call }.to raise_error(Bohu::Shell::ExitStatusError)
        expect { subject.call }.to raise_error('"false" exited with status: 1')
      end
    end
  end
end
