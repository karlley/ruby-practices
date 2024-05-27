#!/usr/bin/env ruby
# frozen_string_literal: true

class Game
  attr_reader :frame

  def initialize(frames)
    @frames = frames
  end

  def to_score
    @frames.each_with_index.sum do |frame, index|
      if index <= 8
        if frame[0] == 10
          @frames[index + 1][0] == 10 ? 10 + 10 + @frames[index + 2][0] : 10 + @frames[index + 1].sum
        elsif frame.sum == 10
          10 + @frames[index + 1][0]
        else
          frame.sum
        end
      else
        frame.sum
      end
    end
  end
end
