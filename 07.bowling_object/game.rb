# frozen_string_literal: true

require './frame'

class Game
  def calculate_total_score
    frames = Frame.new(parse_arguments).to_frames
    frames.each_with_index.sum do |frame, index|
      if index <= 8
        if frame[0] == 10
          frames[index + 1][0] == 10 ? 10 + 10 + frames[index + 2][0] : 10 + frames[index + 1].sum
        elsif frame.sum == 10
          10 + frames[index + 1][0]
        else
          frame.sum
        end
      else
        frame.sum
      end
    end
  end

  private

  def parse_arguments
    ARGV[0].split(',')
  end
end
