#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'lib/input_parser'
require_relative 'lib/entries_generator'
require_relative 'lib/entry'
require_relative 'lib/entry_metadata_builder'
require_relative 'lib/option_applier'
require_relative 'lib/display_content_builder'
require_relative 'lib/display'

class Ls
  def self.run
    path, options = InputParser.parse.values_at(:path, :options)
    entries = EntriesGenerator.new(path).generate
    entries_after_options = OptionApplier.new(options, entries).apply
    display_content = DisplayContentBuilder.build(entries_after_options)
    Display.new(display_content, options).print
  end
end

Ls.run
