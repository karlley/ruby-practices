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
DIGIT_TO_INDEX = {
  '1': -1,
  '4': 2,
  '2': 5
}.freeze
DIGIT_TO_PERMISSION = {
  '1': 't',
  '4': 's',
  '2': 's'
}.freeze

def main
  options = ARGV.getopts('arl')
  path = ARGV[0] || Dir.getwd
  files = select_files(path, all: options['a'], reverse: options['r'])
  options['l'] ? output_file_detail(files, path) : output_file_names(files)
end

def select_files(path, all: false, reverse: false)
  return [path] unless File.lstat(path).directory?

  select_option = all ? File::FNM_DOTMATCH : 0
  selected_files = Dir.glob('*', select_option, base: path)
  reverse ? selected_files.reverse : selected_files
end

def output_file_detail(files, path)
  output_total_blocks(files, path) if files.size > 1
  files.each do |i|
    file = File.lstat(path).directory? ? File.lstat(File.join(path, i)) : File.lstat(i)
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

def output_total_blocks(files, path)
  total_blocks = files.map do |i|
    File.lstat(File.join(path, i)).blocks
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
  update_index = DIGIT_TO_INDEX[special_permission_digit.to_sym]
  special_permission = DIGIT_TO_PERMISSION[special_permission_digit.to_sym]
  permission[update_index] = permission[update_index] == '-' ? special_permission.upcase : special_permission
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
