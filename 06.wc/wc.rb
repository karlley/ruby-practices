#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

CHARACTER_WIDTH = 8

def main
  option = ARGV.getopts('l')
  file_tables = ARGV.size >= 1 ? read_argv : read_stdin
  count_tables = count_file_tables(file_tables)
  output_count_tables(count_tables, option)
  output_total_tables(count_tables, option) if file_tables.size > 1
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

def total_count_tables(count_tables)
  total_count_tables = {}
  total_count_tables[:line_count] = 0
  total_count_tables[:word_count] = 0
  total_count_tables[:byte_count] = 0
  count_tables.each do |count_table|
    total_count_tables[:line_count] += count_table[:line_count]
    total_count_tables[:word_count] += count_table[:word_count]
    total_count_tables[:byte_count] += count_table[:byte_count]
  end
  total_count_tables
end

def output_count_tables(count_tables, option)
  count_tables.each do |count_table|
    if option['l']
      puts "#{convert_to_string(count_table[:line_count])} #{count_table[:file_name]}"
    else
      puts <<~COUNT
        #{convert_to_string(count_table[:line_count])}\
        #{convert_to_string(count_table[:word_count])}\
        #{convert_to_string(count_table[:byte_count])} #{count_table[:file_name]}
      COUNT
    end
  end
end

def output_total_tables(count_tables, option)
  total_tables = total_count_tables(count_tables)
  if option['l']
    puts "#{convert_to_string(total_tables[:line_count])} total"
  else
    puts <<~TOTAL
      #{convert_to_string(total_tables[:line_count])}\
      #{convert_to_string(total_tables[:word_count])}\
      #{convert_to_string(total_tables[:byte_count])} total
    TOTAL
  end
end

def convert_to_string(count_number)
  count_number.to_s.rjust(CHARACTER_WIDTH)
end

main
