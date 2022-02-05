#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COLUMN = 3
COLUMN_WIDTH = 15

def main
  option = ARGV.getopts('a')
  directory = ARGV[0] || Dir.getwd
  files = sort_files(directory, option)
  rows = create_rows(files)
  list_files(rows)
end

def sort_files(directory, option)
  all_files = Dir.glob('*', File::FNM_DOTMATCH, base: directory)
  option['a'] ? all_files : all_files.grep_v(/^[.].*/)
end

def create_rows(files)
  rows = []
  max_row = (files.count / MAX_COLUMN.to_f).ceil
  max_row.times do |t|
    row_items = []
    row_items << files[t].ljust(COLUMN_WIDTH)
    (1...MAX_COLUMN).each do |n|
      row_items << files[t + max_row * n].ljust(COLUMN_WIDTH) unless files[t + max_row * n].nil?
    end
    rows << row_items
  end
  rows
end

def list_files(rows)
  rows.each do |i|
    puts i.join('')
  end
end

main
