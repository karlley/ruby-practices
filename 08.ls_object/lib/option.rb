# frozen_string_literal: true

class Option
  def initialize(options)
    @include_hidden_files = options['a']
    @reverse_order = options['r']
    @show_details = options['l']
  end

  def process(entries)
    filtered_entries = include_hidden_files? ? entries : exclude_hidden_file(entries)
    reverse_order? ? reverse_order(filtered_entries) : filtered_entries
  end

  def show_details?
    @show_details
  end

  private

  def include_hidden_files?
    @include_hidden_files
  end

  def reverse_order?
    @reverse_order
  end

  def exclude_hidden_file(entries)
    entries.reject do |entry|
      entry.name.start_with?('.')
    end
  end

  def reverse_order(entries)
    entries.reverse
  end
end
