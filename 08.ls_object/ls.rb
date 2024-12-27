#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'lib/input'
require_relative 'lib/option'
require_relative 'lib/display_content'
require_relative 'lib/entry'
require_relative 'lib/entry_metadata_builder'

class Ls
  def self.run
    input = Input.new
    option = Option.new(input.options)
    DisplayContent.new(option, input.path, input.entry_names).print
  end
end

Ls.run
