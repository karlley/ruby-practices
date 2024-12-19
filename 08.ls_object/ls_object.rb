#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

class LS
  def self.run
    args = InputParser.parse
    entry_details = EntryDetails.new(args).generate_entry_details
    Display.print(entry_details, args[:options])
  end
end

class InputParser
  def self.parse
    options = ARGV.getopts('arl')
    path = ARGV[0] || Dir.getwd
    { path:, options: }
  end
end

class EntryDetails
  def initialize(args)
    @path = args[:path]
    @options = args[:options]
  end

  def generate_entry_details
    entries = generate_entries
    { entries:, total: calculate_total(entries) }
  end

  def generate_entries
    entry_names.map do |name|
      Entry.new(name, full_path(name))
    end
  end

  def entry_names
    return [@path] unless File.directory?(@path)

    flag = OptionHelper.dotmatch_flag(@options)
    # @pathはフルパスでもokだがnameが必要
    OptionHelper.sort(Dir.glob('*', flag, base: @path), @options)
  end

  def full_path(name)
    # カレントディレクトリ以外のパス指定で必要
    File.directory?(@path) ? File.join(@path, name) : name
  end

  def calculate_total(entries)
    entries.map(&:blocks).sum
  end
end

class OptionHelper
  MAX_COLUMN = 3
  COLUMN_WIDTH = 15

  def self.dotmatch_flag(options)
    options['a'] ? File::FNM_DOTMATCH : 0
  end

  def self.sort(names, options)
    options['r'] ? names.reverse : names
  end

  def self.format(entry_details, options)
    options['l'] ? format_long(entry_details) : format_grid(entry_details)
  end

  def self.format_long(entries)
    entries.map do |entry|
      "#{entry.type}#{entry.permission} #{entry.nlink} #{entry.user}  #{entry.group}  #{entry.size} #{entry.date} #{entry.time} #{entry.name}"
    end
  end

  def self.format_grid(entries)
    rows = []
    row_count = (entries.count / MAX_COLUMN.to_f).ceil
    row_count.times do |row_index|
      entry_names = []
      entry_names << entries[row_index].name.ljust(COLUMN_WIDTH)
      (1...MAX_COLUMN).each do |column_index|
        entry = entries[row_index + row_count * column_index]
        entry_names << entry.name.ljust(COLUMN_WIDTH) if entry
      end
      rows << entry_names.join('')
    end
    rows
  end
end

class Entry
  def initialize(name, path)
    attributes = EntryAttributesBuilder.build(name, path)
    @name = attributes[:name]
    @type = attributes[:type]
    @permission = attributes[:permission]
    @nlink = attributes[:nlink]
    @user = attributes[:user]
    @group = attributes[:group]
    @size = attributes[:size]
    @date = attributes[:date]
    @time = attributes[:time]
    @blocks = attributes[:blocks]
  end

  attr_reader :name, :type, :permission, :nlink, :user, :group, :size, :date, :time, :blocks
end

class EntryAttributesBuilder
  TYPE = {
    'file': '-',
    'directory': 'd',
    'characterSpecial': 'c',
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

  def self.build(name, entry_path)
    stat = File.lstat(entry_path)
    {
      name:,
      type: TYPE[stat.ftype.to_sym],
      permission: convert_to_permission(stat),
      nlink: format_nlink(stat),
      user: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: format_size(stat),
      date: format_date(stat),
      time: format_time(stat),
      blocks: stat.blocks
    }
  end

  def self.convert_to_permission(stat)
    permission_digits = stat.mode.to_s(8)[-3, 3].split('')
    permission = permission_digits.map do |permission_digit|
      PERMISSION[permission_digit.to_sym]
    end.join
    special_permission_digit = stat.mode.to_s(8)[-4]
    special_permission_digit == '0' ? permission : add_special_permission(permission, special_permission_digit)
  end

  def self.add_special_permission(permission, special_permission_digit)
    update_index = DIGIT_TO_INDEX[special_permission_digit.to_sym]
    special_permission = DIGIT_TO_PERMISSION[special_permission_digit.to_sym]
    permission[update_index] = permission[update_index] == '-' ? special_permission.upcase : special_permission
    permission
  end

  def self.format_nlink(stat)
    stat.nlink.to_s.rjust(2)
  end

  def self.format_size(stat)
    stat.size.to_s.rjust(4)
  end

  def self.format_date(stat)
    "#{stat.mtime.month.to_s.rjust(2)} #{stat.mtime.day.to_s.rjust(2)}"
  end

  def self.format_time(stat)
    "#{stat.mtime.strftime('%H')}:#{stat.mtime.strftime('%M')}"
  end
end

class Display
  def self.print(entry_details, options)
    formatted_entries = OptionHelper.format(entry_details[:entries], options)
    total = entry_details[:total]
    options['l'] ? print_long_format(formatted_entries, total) : print_grid(formatted_entries)
  end

  def self.print_long_format(entries, total)
    puts "total #{total}" if entries.size > 1
    entries.each do |entry|
      puts entry
    end
  end

  def self.print_grid(entries)
    entries.each do |row|
      puts row
    end
  end
end

LS.run
