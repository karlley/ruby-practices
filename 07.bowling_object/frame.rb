# frozen_string_literal: true

require_relative 'shot'

class Frame
  MAX_SCORE = 10

  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(marks)
    @first_shot = Shot.new(marks[0])
    @second_shot = Shot.new(marks[1])
    @third_shot = Shot.new(marks[2])
  end

  def strike?
    first_shot.score == MAX_SCORE
  end

  def spare?
    !strike? && first_shot.score + second_shot.score == MAX_SCORE
  end

  def score
    [@first_shot, @second_shot, @third_shot].compact.sum(&:score)
  end
end
