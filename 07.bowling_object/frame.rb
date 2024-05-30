# frozen_string_literal: true

require './shot'

class Frame
  def initialize(shots)
    @shots = shots
  end

  def to_frames
    @shots.map do |shot|
      Shot.new(shot).to_score
    end.flatten.each_slice(2).to_a
  end
end
