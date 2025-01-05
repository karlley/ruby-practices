# frozen_string_literal: true

class Option
  def initialize(options)
    @include_hidden_files = options['a']
    @reverse_order = options['r']
    @show_details = options['l']
  end

  def show_details?
    @show_details
  end

  def include_hidden_files?
    @include_hidden_files
  end

  def reverse_order?
    @reverse_order
  end
end
