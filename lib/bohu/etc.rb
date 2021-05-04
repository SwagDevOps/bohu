# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Provide shell.
class Bohu::Etc
  autoload :Etc, 'etc'

  include Bohu::Configurable

  # Get content of ``/etc/group`` file as a ``Hash``.
  #
  # @return [Hash{String => Etc::Group}]
  def groups
    {}.tap do |groups|
      endpwent do
        ::Etc.group { |g| groups[g.name] = g }
      end
    end.freeze
  end

  # Get content of ``/etc/passwd`` file as a ``Hash``.
  #
  # @return [Hash{String => Etc::Passwd}]
  def passwd
    {}.tap do |users|
      endpwent do
        ::Etc.passwd { |u| users[u.name] = u }
      end
    end.freeze
  end

  # Get system information obtained by uname system call.
  #
  # @return [Hash{Symbol => String}]
  def uname
    ::Etc.uname
  end

  protected

  # Ends the process of scanning ``/etc`` file begun
  #
  # @see https://ruby-doc.org/stdlib-2.3.0/libdoc/etc/rdoc/Etc.html#method-c-endpwent
  def endpwent
    Etc.endpwent
    yield if block_given?
    Etc.endpwent
  end
end
