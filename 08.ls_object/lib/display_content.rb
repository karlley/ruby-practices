# frozen_string_literal: true

class DisplayContent
  MAX_COLUMN = 3
  COLUMN_WIDTH = 15
  def initialize(option, path)
    @option = option
    @entries = generate_entries(fetch_entry_names(path), path)
  end

  def print
    processed_entries = process_entries_with_options(@entries)
    if @option.show_details?
      rows = build_details(processed_entries)
      entries_total = calculate_total(processed_entries)
      entries_size = rows.size
    else
      rows = build_names(processed_entries)
    end

    puts "total #{entries_total}" if @option.show_details? && entries_size > 1
    rows.each do |row|
      puts row
    end
  end

  private

  def fetch_entry_names(path)
    return [path] unless File.directory?(path)

    Dir.glob('*', File::FNM_DOTMATCH, base: path)
  end

  def generate_entries(entry_names, path)
    entry_names.map do |name|
      FileMetaData.new(name, full_path(name, path))
    end
  end

  def full_path(name, path)
    File.directory?(path) ? File.join(path, name) : name
  end

  def process_entries_with_options(entries)
    filtered_entries = @option.include_hidden_files? ? entries : exclude_hidden_file(entries)
    @option.reverse_order? ? reverse_order(filtered_entries) : filtered_entries
  end

  def exclude_hidden_file(entries)
    entries.reject do |entry|
      entry.name.start_with?('.')
    end
  end

  def reverse_order(entries)
    entries.reverse
  end

  def format_nlink(nlink)
    nlink.to_s.rjust(2)
  end

  def format_size(size)
    size.to_s.rjust(4)
  end

  def format_date(mtime)
    "#{mtime.month.to_s.rjust(2)} #{mtime.day.to_s.rjust(2)}"
  end

  def format_time(mtime)
    "#{mtime.strftime('%H')}:#{mtime.strftime('%M')}"
  end

  def build_details(entries)
    entries.map do |entry|
      "#{entry.type}#{entry.permission} #{format_nlink(entry.nlink)} #{entry.user}  #{entry.group}
 #{format_size(entry.size)} #{format_date(entry.mtime)} #{format_time(entry.mtime)} #{entry.name}".delete("\n")
    end
  end

  def calculate_total(entries)
    entries.map(&:blocks).sum
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
end
