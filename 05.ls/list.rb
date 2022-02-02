#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMN = 3
COLUMN_WIDTH = 15

def main
  directory = ARGV[0] || Dir.getwd
  segments = sort_segments(directory)
  rows = create_rows(segments)
  list_segments(rows)
end

def sort_segments(directory)
  Dir.glob('*', base: directory)
end

def create_rows(segments)
  rows = []
  max_row = (segments.count / MAX_COLUMN.to_f).ceil
  max_row.times do |t|
    items = []
    items << segments[t].ljust(COLUMN_WIDTH)
    (1...MAX_COLUMN).each do |n|
      items << segments[t + max_row * n].ljust(COLUMN_WIDTH) unless segments[t + max_row * n].nil?
    end
    rows << items
  end
  rows
end

def list_segments(rows)
  rows.each do |i|
    puts i.join('')
  end
end

main
