# frozen_string_literal: true

# class methods
describe Bohu::Shell, :shell do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
  it { expect(described_class).to respond_to(:new).with(2).arguments }
end

# instance
describe Bohu::Shell, :shell do
  let(:subject) { described_class.new(shell: {}) }

  it { expect(subject).to respond_to(:sh).with_unlimited_arguments }
end

# testing output
describe Bohu::Shell, :shell do
  let(:subject) { described_class.new(config) }
  let(:command) { ['true'] }

  context '#sh' do
    let(:config) { { shell: {} } }

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }.to output(/true$/).to_stderr
        expect { subject.sh(*command) }.to_not output.to_stdout
      end
    end
  end

  context '#sh' do
    let(:config) { { shell: { verbose: false } } }

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }.to_not output.to_stderr
        expect { subject.sh(*command) }.to_not output.to_stdout
      end
    end
  end
end

describe Bohu::Shell, :shell do
  let(:subject) { described_class.new(shell: {}) }

  # command with arguments
  context '#sh' do
    let(:command) { ['true', '42', 'foo', 'bar'] }

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }
          .to output(/true 42 foo bar$/).to_stderr
      end
    end
  end

  # command with arguments (shell escape)
  context '#sh' do
    let(:command) { ['true', '42', 'foo bar'] }

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }
          .to output(/true 42 foo\\ bar$/).to_stderr
      end
    end
  end
end

describe Bohu::Shell, :shell do
  let(:subject) { described_class.new(shell: {}) }

  context '#sh' do # testing exceptions
    let(:command) { ['false'] } # exit 1

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }
          .to raise_error(Bohu::Shell::ExitStatusError)

        expect { subject.sh(*command) }
          .to raise_error('"false" exited with status: 1')
      end
    end
  end

  context '#sh' do # testing result
    let(:command) { ['true'] } # exit 0

    specify do
      silence_stream($stderr) do
        expect(subject.sh(*command)).to be_a(Bohu::Shell::Result)
      end
    end
  end
end
