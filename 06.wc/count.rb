#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  texts = ARGV.size >= 1 ? read_argv : read_stdin
  text_details = count_texts(texts)
  output_text_details(text_details, option)
end

def read_argv
  texts = []
  ARGV.each do |file|
    text = {}
    text[:text] = File.readlines(file)
    text[:file_name] = file
    texts << text
  end
  texts
end

def read_stdin
  text = {}
  text[:text] = $stdin.readlines
  text[:file_name] = nil
  [text]
end

def count_texts(texts)
  text_details = []
  texts.each do |text|
    text_detail = {}
    text_detail[:file_name] = text[:file_name]
    text_detail[:line_count] = text[:text].size
    word_counts = []
    byte_counts = []
    text[:text].each do |line|
      word_counts << line.split.size
      byte_counts << line.split(//).size
    end
    text_detail[:word_count] = word_counts.sum
    text_detail[:byte_count] = byte_counts.sum
    text_details << text_detail
  end
  text_details
end

def output_text_details(text_details, option)
  text_details.each do |text|
    if option['l']
      puts "#{text[:line_count].to_s.rjust(8)} #{text[:file_name]}"
    else
      puts "#{text[:line_count].to_s.rjust(8)}#{text[:word_count].to_s.rjust(8)}#{text[:byte_count].to_s.rjust(8)} #{text[:file_name]}"
    end
  end
  output_total(text_details, option) if text_details.size > 1
end

def output_total(text_details, option)
  line_counts = []
  word_counts = []
  byte_counts = []
  text_details.each do |text|
    line_counts << text[:line_count]
    word_counts << text[:word_count]
    byte_counts << text[:byte_count]
  end
  total = {}
  total[:line_count] = line_counts.sum
  total[:word_count] = word_counts.sum
  total[:byte_count] = byte_counts.sum
  if option['l']
    puts "#{total[:line_count].to_s.rjust(8)} total"
  else
    puts "#{total[:line_count].to_s.rjust(8)}#{total[:word_count].to_s.rjust(8)}#{total[:byte_count].to_s.rjust(8)} total"
  end
end

main
