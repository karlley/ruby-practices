#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'lib/ls'
require_relative 'lib/input_parser'
require_relative 'lib/entries_generator'
require_relative 'lib/entry'
require_relative 'lib/entry_metadata_builder'
require_relative 'lib/option_applier'
require_relative 'lib/display_content_builder'
require_relative 'lib/display'

LS.run
