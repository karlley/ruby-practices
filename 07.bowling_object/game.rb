# frozen_string_literal: true

require './frame'

class Game
  def initialize
    @shots = parse_arguments
  end

  def calculate_total_score
    frames = Frame.new(@shots).to_frames
    frames.each_with_index.sum do |frame, index|
      calculate_frame_score(frames, frame, index)
    end
  end

  private

  def parse_arguments
    raise ArgumentError, '引数を渡してください' if ARGV.empty?

    ARGV[0].split(',')
  end

  def calculate_frame_score(frames, frame, index)
    if index <= 8
      if frame[0] == 10
        calculate_strike_score(frames, index)
      elsif frame.sum == 10
        calculate_spare_score(frames, index)
      else
        frame.sum
      end
    else
      frame.sum
    end
  end

  def calculate_strike_score(frames, index)
    frames[index + 1][0] == 10 ? 10 + 10 + frames[index + 2][0] : 10 + frames[index + 1].sum
  end

  def calculate_spare_score(frames, index)
    10 + frames[index + 1][0]
  end
end
