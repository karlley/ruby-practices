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
  SPECIAL_PERMISSION_INDEX_MAP = {
    1 => [8],
    2 => [5],
    3 => [5, 8],
    4 => [2],
    5 => [2, 8],
    6 => [2, 5],
    7 => [2, 5, 8]
  }.freeze
  SPECIAL_PERMISSION_CHAR = {
    2 => 's',
    5 => 's',
    8 => 't'
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
    special_permission_digit == '0' ? permission : apply_special_permission(permission, special_permission_digit)
  end

  def apply_special_permission(permission, special_permission_digit)
    SPECIAL_PERMISSION_INDEX_MAP[special_permission_digit.to_i]&.each do |index|
      permission[index] = permission[index] == '-' ? SPECIAL_PERMISSION_CHAR[index].upcase : SPECIAL_PERMISSION_CHAR[index]
    end
    permission
  end
end
