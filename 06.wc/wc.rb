#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

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
    line_counts = []
    word_counts = []
    byte_counts = []
    file[:lines].each do |line|
      line_counts << line.count("\n")
      word_counts << line.split.size
      byte_counts << line.bytesize
    end
    count_table[:line_count] = line_counts.sum
    count_table[:word_count] = word_counts.sum
    count_table[:byte_count] = byte_counts.sum
    count_tables << count_table
  end
  count_tables
end

def total_count_tables(count_tables)
  line_count_totals = []
  word_count_totals = []
  byte_count_totals = []
  count_tables.each do |i|
    line_count_totals << i[:line_count]
    word_count_totals << i[:word_count]
    byte_count_totals << i[:byte_count]
  end
  total = {}
  total[:line_count] = line_count_totals.sum
  total[:word_count] = word_count_totals.sum
  total[:byte_count] = byte_count_totals.sum
  total
end

def output_count_tables(count_tables, total_count_tables, option)
  count_tables.each do |i|
    if option['l']
      puts "#{i[:line_count].to_s.rjust(8)} #{i[:file_name]}"
    else
      puts "#{i[:line_count].to_s.rjust(8)}#{i[:word_count].to_s.rjust(8)}#{i[:byte_count].to_s.rjust(8)} #{i[:file_name]}"
    end
  end
  output_total_count_tables(total_count_tables, option) if count_tables.size > 1
end

def output_total_count_tables(total_count_tables, option)
  if option['l']
    puts "#{total_count_tables[:line_count].to_s.rjust(8)} total"
  else
    puts "#{total_count_tables[:line_count].to_s.rjust(8)}#{total_count_tables[:word_count].to_s.rjust(8)}#{total_count_tables[:byte_count].to_s.rjust(8)} total"
  end
end

main
