# frozen_string_literal: true

class OptionApplier
  def initialize(options, entries)
    @options = options
    @entries = entries
  end

  def apply
    @entries = exclude_hidden_file unless @options['a']
    @entries = reverse_order if @options['r']
    @entries
  end

  def exclude_hidden_file
    @entries.reject do |entry|
      entry.name.start_with?('.')
    end
  end

  def reverse_order
    @entries.reverse
  end
end
