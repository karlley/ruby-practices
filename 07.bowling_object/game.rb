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
      if index <= LAST_REGULAR_FRAME
        next_frame = @frames[index + 1]
        double_shot_score(frame, next_frame, index) +
          strike_score(frame, next_frame) +
          spare_score(frame, next_frame) +
          open_score(frame)
      elsif index == LAST_FRAME
        frame.score
      end
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

  def double_shot_score(frame, next_frame, index)
    return 0 unless frame.strike? && next_frame.strike?

    next_next_frame = @frames[index + 2]
    third_shot_score = if index == LAST_REGULAR_FRAME
                         next_frame.second_shot.score
                       else
                         next_next_frame.first_shot.score
                       end
    frame.score + next_frame.first_shot.score + third_shot_score
  end

  def strike_score(frame, next_frame)
    return 0 unless frame.strike? && !next_frame.strike?

    frame.score + next_frame.first_shot.score + next_frame.second_shot.score
  end

  def spare_score(frame, next_frame)
    return 0 unless frame.spare?

    frame.score + next_frame.first_shot.score
  end

  def open_score(frame)
    return 0 if frame.strike? || frame.spare?

    frame.score
  end
end
