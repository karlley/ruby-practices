# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(inputs)
    frame_marks = split_to_frame_marks(inputs)
    @frames = frame_marks.map { |marks| Frame.new(marks) }
  end

  def total_score
    @frames.each_with_index.sum do |frame, index|
      if index <= 8
        next_frame = @frames[index + 1]
        double_shot_score(frame, next_frame, index) +
        strike_score(frame, next_frame) +
        spare_score(frame, next_frame) +
        open_score(frame)
      else
        frame.score
      end
    end
  end

  private

  # ストライクの場合は[X, 0]に変換
  # 10フレーム以降の[X, 0]の0を削除
  # 10フレーム以降を1つのフレームに結合して最終フレーム化
  def split_to_frame_marks(inputs)
    frames = inputs.map do |input|
      input == 'X' ? %w[X 0] : input
    end.flatten.each_slice(2).to_a
    frames[9..].each { |frame| frame.pop if frame[0] == 'X' }
    to_9_frames = frames.slice(..8)
    last_frame = frames.slice(9..).flatten
    to_9_frames << last_frame
  end

  def double_shot_score(frame, next_frame, index)
    return 0 unless frame.strike? && next_frame.strike?

    next_next_frame = @frames[index + 2]
    second_shot_score = if index == 8
                          next_frame.second_shot.score
                        else
                          next_next_frame.first_shot.score
                        end
    frame.score + next_frame.first_shot.score + second_shot_score
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
