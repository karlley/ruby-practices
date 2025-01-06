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
    metadata = build_metadata(name, path)
    @name = metadata[:name]
    @type = metadata[:type]
    @permission = metadata[:permission]
    @nlink = metadata[:nlink]
    @user = metadata[:user]
    @group = metadata[:group]
    @size = metadata[:size]
    @date = metadata[:date]
    @time = metadata[:time]
    @blocks = metadata[:blocks]
  end

  attr_reader :name, :type, :permission, :nlink, :user, :group, :size, :date, :time, :blocks

  private

  def build_metadata(name, path)
    stat = File.lstat(path)
    {
      name:,
      type: TYPE[stat.ftype.to_sym],
      permission: convert_to_permission(stat),
      nlink: DisplayContent.format_nlink(stat),
      user: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: DisplayContent.format_size(stat),
      date: DisplayContent.format_date(stat),
      time: DisplayContent.format_time(stat),
      blocks: stat.blocks
    }
  end

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
