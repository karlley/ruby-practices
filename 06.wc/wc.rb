#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

CHARACTER_WIDTH = 8

def main
  option = ARGV.getopts('l')
  file_tables = ARGV.size >= 1 ? read_argv : read_stdin
  count_tables = count_file_tables(file_tables)
  total_count_tables = total_count_tables(count_tables)
  output_count_tables(count_tables, total_count_tables, option)
end

def read_argv
  ARGV.map do |i|
    file_table = {}
    file_table[:lines] = File.readlines(i)
    file_table[:file_name] = i
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
  count_tables = []
  file_tables.each do |file|
    count_table = {}
    count_table[:file_name] = file[:file_name]
    count_table[:line_count] = 0
    count_table[:word_count] = 0
    count_table[:byte_count] = 0
    file[:lines].each do |line|
      count_table[:line_count] += line.count("\n")
      count_table[:word_count] += line.split.size
      count_table[:byte_count] += line.bytesize
    end
    count_tables << count_table
  end
  count_tables
end

def total_count_tables(count_tables)
  total_count_tables = {}
  total_count_tables[:line_count] = 0
  total_count_tables[:word_count] = 0
  total_count_tables[:byte_count] = 0
  count_tables.each do |i|
    total_count_tables[:line_count] += i[:line_count]
    total_count_tables[:word_count] += i[:word_count]
    total_count_tables[:byte_count] += i[:byte_count]
  end
  total_count_tables
end

def output_count_tables(count_tables, total_count_tables, option)
  count_tables.each do |i|
    if option['l']
      puts "#{convert_to_string(i[:line_count])} #{i[:file_name]}"
    else
      puts "#{convert_to_string(i[:line_count])}#{convert_to_string(i[:word_count])}#{convert_to_string(i[:byte_count])} #{i[:file_name]}"
    end
  end
  output_total_count_tables(total_count_tables, option) if count_tables.size > 1
end

def output_total_count_tables(total_count_tables, option)
  if option['l']
    puts "#{convert_to_string(total_count_tables[:line_count])} total"
  else
    puts "#{convert_to_string(total_count_tables[:line_count])}#{convert_to_string(total_count_tables[:word_count])}#{convert_to_string(total_count_tables[:byte_count])} total"
  end
end

def convert_to_string(count_number)
  count_number.to_s.rjust(CHARACTER_WIDTH)
end

main
