# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(marks)
    shot_variables = %w[@first_shot @second_shot @third_shot]
    marks.each_with_index do |mark, index|
      instance_variable_set(shot_variables[index], Shot.new(mark))
    end
  end

  def score
    [@first_shot, @second_shot, @third_shot].compact.sum(&:score)
  end
end
