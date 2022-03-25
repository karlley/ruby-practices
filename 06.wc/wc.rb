#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  file_tables = ARGV.size >= 1 ? read_argv : read_stdin
  text_details = count_texts(file_tables)
  total = count_texts_total(text_details)
  output_text_details(text_details, total, option)
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

def count_texts(file_tables)
  text_details = []
  file_tables.each do |file|
    text_detail = {}
    text_detail[:file_name] = file[:file_name]
    line_counts = []
    word_counts = []
    byte_counts = []
    file[:lines].each do |line|
      line_counts << line.count("\n")
      word_counts << line.split.size
      byte_counts << line.bytesize
    end
    text_detail[:line_count] = line_counts.sum
    text_detail[:word_count] = word_counts.sum
    text_detail[:byte_count] = byte_counts.sum
    text_details << text_detail
  end
  text_details
end

def count_texts_total(text_details)
  line_count_totals = []
  word_count_totals = []
  byte_count_totals = []
  text_details.each do |text|
    line_count_totals << text[:line_count]
    word_count_totals << text[:word_count]
    byte_count_totals << text[:byte_count]
  end
  total = {}
  total[:line_count] = line_count_totals.sum
  total[:word_count] = word_count_totals.sum
  total[:byte_count] = byte_count_totals.sum
  total
end

def output_text_details(text_details, total, option)
  text_details.each do |text|
    if option['l']
      puts "#{text[:line_count].to_s.rjust(8)} #{text[:file_name]}"
    else
      puts "#{text[:line_count].to_s.rjust(8)}#{text[:word_count].to_s.rjust(8)}#{text[:byte_count].to_s.rjust(8)} #{text[:file_name]}"
    end
  end
  output_total(total, option) if text_details.size > 1
end

def output_total(total, option)
  if option['l']
    puts "#{total[:line_count].to_s.rjust(8)} total"
  else
    puts "#{total[:line_count].to_s.rjust(8)}#{total[:word_count].to_s.rjust(8)}#{total[:byte_count].to_s.rjust(8)} total"
  end
end

main
