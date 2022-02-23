#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMN = 3
COLUMN_WIDTH = 15
FILE_TYPE = {
  'file': '-',
  'directory': 'd',
  'caracterSpecial': 'c',
  'blockSpecial': 'b',
  'fifo': 'p',
  'link': 'l',
  'socket': 's',
  'unknown': ''
}.freeze
PERMISSION = {
  '0': '---',
  '1': '--x',
  '2': '-w-',
  '3': '-wx',
  '4': 'r--',
  '5': 'r-x',
  '6': 'rw-',
  '7': 'rwx'
}.freeze

def main
  option = ARGV.getopts('l')
  argument_path = ARGV[0] || Dir.getwd
  files = directory?(argument_path) ? select_files(argument_path) : [argument_path]
  option['l'] ? output_file_detail(files, argument_path) : output_file_names(files)
end

def directory?(argument_path)
  File.lstat(argument_path).directory?
end

def select_files(argument_path)
  Dir.glob('*', base: argument_path)
end

def output_file_detail(files, argument_path)
  output_total_blocks(files, argument_path) if files.size > 1
  files.each do |i|
    file = directory?(argument_path) ? File.lstat(File.join(argument_path, i)) : File.lstat(i)
    type = FILE_TYPE[file.ftype.to_sym]
    permission = convert_to_permission(file)
    nlink = file.nlink.to_s.rjust(2)
    user = Etc.getpwuid(file.uid).name
    group = Etc.getgrgid(file.gid).name
    size = file.size.to_s.rjust(4)
    date = "#{file.mtime.month.to_s.rjust(2)} #{file.mtime.day.to_s.rjust(2)}"
    time = "#{file.mtime.strftime('%H')}:#{file.mtime.strftime('%M')}"
    puts "#{type}#{permission} #{nlink} #{user}  #{group} #{size} #{date} #{time} #{i}"
  end
end

def output_total_blocks(files, argument_path)
  total_blocks = files.map do |i|
    File.lstat(File.join(argument_path, i)).blocks
  end.sum
  puts "total #{total_blocks}"
end

def convert_to_permission(file)
  permission_digits = file.mode.to_s(8)[-3, 3].split('')
  permission = permission_digits.map do |i|
    PERMISSION[i.to_sym]
  end.join
  special_permission_digit = file.mode.to_s(8)[-4]
  special_permission_digit == '0' ? permission : add_special_permission(permission, special_permission_digit)
end

def add_special_permission(permission, special_permission_digit)
  case special_permission_digit
  when '1'
    permission[-1] = permission[-1] == '-' ? 'T' : 't'
  when '4'
    permission[2] = permission[2] == '-' ? 'S' : 's'
  when '2'
    permission[5] = permission[5] == '-' ? 'S' : 's'
  end
  permission
end

def output_file_names(files)
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
  rows.each do |i|
    puts i.join('')
  end
end

main
