#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Command
  def self.path
    ARGV[0] || Dir.getwd
  end

  def self.options
    ARGV.getopts('ar')
  end
end

class FileScan
  def initialize(path, options: false)
    @path = path
    @options = options
  end

  def a_option
    @options['a'] ? File::FNM_DOTMATCH : 0
  end

  def r_option(names)
    @options['r'] ? names.reverse : names
  end

  def names
    r_option(Dir.glob('*', a_option, base: @path))
  end

  def entries
    names.map do |name|
      FileEntry.new(name)
    end
  end
end

class FileEntry
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

class Display
  def initialize(entries, options = [])
    @entries = entries
    @options = options
  end

  MAX_COLUMN = 3
  COLUMN_WIDTH = 15

  def names
    @entries.map(&:name)
  end

  def create_rows
    rows = []
    row_count = (@entries.count / MAX_COLUMN.to_f).ceil
    row_count.times do |row_index|
      entry_names = []
      # 1つ目の要素
      entry_names << @entries[row_index].name.ljust(COLUMN_WIDTH)
      # 2つ目以降の要素
      (1...MAX_COLUMN).each do |column_index|
        entry = @entries[row_index + row_count * column_index]
        entry_names << entry.name.ljust(COLUMN_WIDTH) if entry
      end
      rows << entry_names
    end
    rows
  end

  def print
    create_rows.each do |row|
      puts row.join('')
    end
  end
end

def main
  options = Command.options
  path = Command.path
  entries = FileScan.new(path, options:).entries
  Display.new(entries).print
end

main
