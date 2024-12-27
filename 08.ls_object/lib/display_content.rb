# frozen_string_literal: true

class DisplayContent
  MAX_COLUMN = 3
  COLUMN_WIDTH = 15
  def initialize(option, path, entry_names)
    @option = option
    entries = generate_entries(entry_names, path)
    processed_entries = @option.process(entries)
    @entry_names = build_names(processed_entries)
    @entry_details = build_details(processed_entries)
    @entry_total = calculate_total(processed_entries)
  end

  def print
    rows = @option.show_details? ? @entry_details : @entry_names
    puts "total #{@entry_total}" if @option.show_details? && @entry_details.size > 1
    rows.each do |row|
      puts row
    end
  end

  private

  def generate_entries(entry_names, path)
    entry_names.map do |name|
      Entry.new(name, full_path(name, path))
    end
  end

  def full_path(name, path)
    File.directory?(path) ? File.join(path, name) : name
  end

  def build_names(entries)
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

  def build_details(entries)
    entries.map do |entry|
      "#{entry.type}#{entry.permission} #{entry.nlink} #{entry.user}  #{entry.group}  #{entry.size} #{entry.date} #{entry.time} #{entry.name}"
    end
  end

  def calculate_total(entries)
    entries.map(&:blocks).sum
  end
end
