#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

CHARACTER_WIDTH = 8

def main
  option = ARGV.getopts('l')
  file_tables = ARGV.size >= 1 ? read_argv : read_stdin
  count_tables = count_file_tables(file_tables)
  output_count_tables(option, file_tables, count_tables)
end

def read_argv
  ARGV.map do |file|
    file_table = {}
    file_table[:lines] = File.readlines(file)
    file_table[:file_name] = file
    file_table
  end
end

def read_stdin
  file_table = {}
  file_table[:lines] = $stdin.readlines
  file_table[:file_name] = nil
  [file_table]
end

def count_file_tables(file_tables)
  file_tables.map do |file_table|
    count_table = { line_count: 0, word_count: 0, byte_count: 0 }
    count_table[:file_name] = file_table[:file_name]
    file_table[:lines].each do |line|
      count_table[:line_count] += line.count("\n")
      count_table[:word_count] += line.split.size
      count_table[:byte_count] += line.bytesize
    end
    count_table
  end
end

def output_count_tables(option, file_tables, count_tables)
  count_tables.each do |count_table|
    show_table(count_table, option)
  end
  return unless file_tables.size > 1

  total_table = sum_count_tables(count_tables)
  show_table(total_table, option)
end

def show_table(output_table, option)
  if option['l']
    puts "#{format_number(output_table[:line_count])} #{output_table[:file_name]}"
  else
    puts "#{format_number(output_table[:line_count])}"\
          "#{format_number(output_table[:word_count])}"\
          "#{format_number(output_table[:byte_count])} #{output_table[:file_name]}"
  end
end

def sum_count_tables(count_tables)
  total_table = { line_count: 0, word_count: 0, byte_count: 0, file_name: 'total' }
  count_tables.each do |count_table|
    total_table[:line_count] += count_table[:line_count]
    total_table[:word_count] += count_table[:word_count]
    total_table[:byte_count] += count_table[:byte_count]
  end
  total_table
end

def format_number(count_number)
  count_number.to_s.rjust(CHARACTER_WIDTH)
end

main
