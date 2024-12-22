# frozen_string_literal: true

class DisplayContentBuilder
  MAX_COLUMN = 3
  COLUMN_WIDTH = 15

  def self.build(entries)
    {
      names: build_names(entries),
      details: build_details(entries),
      total: calculate_total(entries)
    }
  end

  def self.build_names(entries)
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

  def self.build_details(entries)
    entries.map do |entry|
      "#{entry.type}#{entry.permission} #{entry.nlink} #{entry.user}  #{entry.group}  #{entry.size} #{entry.date} #{entry.time} #{entry.name}"
    end
  end

  def self.calculate_total(entries)
    entries.map(&:blocks).sum
  end
end
