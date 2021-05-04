# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../dot_hash'

# Use dot syntax with Ruby hashes.
#
# Sample of use:
#
# ```ruby
# user = {}.extend(Bohu::DotHash::Behavior)
# user.merge!(name: 'Anna', job: {title: 'Programmer'})
# user.job.title #=> 'Programmer'
# user.job.title = 'Senior Programmer'
# user.job.title #=> 'Senior Programmer'
# ```
module Bohu::DotHash::Behavior
  autoload :OpenStruct, 'ostruct'

  self.tap do |mod|
    define_method(:method_missing) do |method, *args, &block|
      unless respond_to_missing?(method)
        return super(method, *args, &block)
      end

      method_status(method).tap do |stt|
        self.fetch(stt.key).tap do |value|
          return self.public_send('[]=', *[stt.key].push(*args)) if stt.eql

          value.extend(mod) if value.is_a?(Hash)
          return value
        end
      end
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if method_status(method).seen

    super(method, include_private)
  end

  # @return [Hash]
  def to_h
    Hash[super]
  end

  protected

  # Get status for given method.
  #
  # @return [OpenStruct]
  def method_status(method)
    method = method.to_s

    OpenStruct.new(key: method.to_s.gsub(/=$/, ''),
                   eql: method.to_s[-1] == '=').tap do |res|
      res.key = res.key.to_sym if key?(res.key.to_sym)

      res.seen = key?(res.key)
    end
  end
end
