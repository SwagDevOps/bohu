# frozen_string_literal: true

require 'bohu/command'

# class methods
describe Bohu::Command::Dialect, :'command/dialect' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

# instance
describe Bohu::Command::Dialect, :'command/dialect' do
  let(:subject) { described_class.new({}) }

  it { expect(subject).to be_a(Hash) }
end
