# frozen_string_literal: true

class FileMetaData
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

  def initialize(name, path)
    @name = name
    @stat = File.lstat(path)
  end

  attr_reader :name

  def type
    TYPE[@stat.ftype.to_sym]
  end

  def permission
    convert_to_permission(@stat)
  end

  def nlink
    @stat.nlink
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end

  def blocks
    @stat.blocks
  end

  private

  def convert_to_permission(stat)
    permission_digits = stat.mode.to_s(8)[-3, 3].split('')
    permission = permission_digits.map do |digit|
      PERMISSION[digit.to_sym]
    end.join
    special_permission_digit = stat.mode.to_s(8)[-4]
    special_permission_digit == '0' ? permission : add_special_permission(permission, special_permission_digit)
  end

  def add_special_permission(permission, special_permission_digit)
    update_index = DIGIT_TO_INDEX[special_permission_digit.to_sym]
    special_permission = DIGIT_TO_PERMISSION[special_permission_digit.to_sym]
    permission[update_index] = permission[update_index] == '-' ? special_permission.upcase : special_permission
    permission
  end
end
