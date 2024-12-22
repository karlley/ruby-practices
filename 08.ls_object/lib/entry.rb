# frozen_string_literal: true

class Entry
  def initialize(name, path)
    metadata = EntryMetadataBuilder.build(name, path)
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
end
