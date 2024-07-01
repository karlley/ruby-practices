# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_REGULAR_FRAME = 8
  LAST_FRAME = 9

  def initialize(inputs)
    frame_marks = generate_frame_marks(inputs)
    @frames = frame_marks.map { |marks| Frame.new(marks) }
  end

  def total_score
    @frames.each_with_index.sum do |frame, index|
      frame.score + bonus_score(frame, index)
    end
  end

  private

  def generate_frame_marks(inputs)
    frames = parse_inputs_to_frames(inputs)
    frames.slice(..LAST_REGULAR_FRAME) << remove_extra_zero(frames.slice(LAST_FRAME..))
  end

  def parse_inputs_to_frames(inputs)
    inputs.map do |input|
      input == 'X' ? %w[X 0] : input
    end.flatten.each_slice(2).to_a
  end

  def remove_extra_zero(frames)
    frames.each { |frame| frame.pop if frame[0] == 'X' }.flatten
  end

  def bonus_score(frame, index)
    return 0 if index == LAST_FRAME

    next_frame = @frames[index + 1]
    if frame.strike?
      strike_score(next_frame, index)
    elsif frame.spare?
      spare_score(next_frame)
    else
      0
    end
  end

  def strike_score(next_frame, index)
    if next_frame.strike?
      next_frame.first_shot.score + second_shot_score(next_frame, index)
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def second_shot_score(next_frame, index)
    next_next_frame = @frames[index + 2]
    if index == LAST_REGULAR_FRAME
      next_frame.second_shot.score
    else
      next_next_frame.first_shot.score
    end
  end

  def spare_score(next_frame)
    next_frame.first_shot.score
  end
end
