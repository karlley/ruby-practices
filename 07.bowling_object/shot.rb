#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  attr_accessor :mark

  def initialize(marks)
    @marks = marks
  end

  def to_shots
    @marks.map do |mark|
      mark == 'X' ? [10, 0] : mark.to_i
    end.flatten
  end
end
