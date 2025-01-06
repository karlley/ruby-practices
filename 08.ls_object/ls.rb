#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'lib/command_line_arguments'
require_relative 'lib/option'
require_relative 'lib/display_content'
require_relative 'lib/file_meta_data'

class Ls
  def self.run
    args = CommandLineArguments.new
    option = Option.new(args.options)
    DisplayContent.new(option, args.path).print
  end
end

Ls.run
