# frozen_string_literal: true

class Option
  def initialize(options)
    @options = options
  end

  def show_details?
    @options['l']
  end

  def include_hidden_files?
    @options['a']
  end

  def reverse_order?
    @options['r']
  end
end
