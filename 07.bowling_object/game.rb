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
        next_next_frame = @frames[index + 2]

        case
        when double_strike?(frame, next_frame)
          double_strike_score(frame, next_frame, next_next_frame)
        when frame.strike?
          strike_score(frame, next_frame)
        when frame.spare?
          spare_score(frame, next_frame)
        else
          frame.score
        end
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

  def double_strike?(frame, next_frame)
    frame.strike? && next_frame.strike?
  end

  def double_strike_score(frame, next_frame, next_next_frame)
    frame.score + next_frame.first_shot.score + third_shot_score(next_frame, next_next_frame)
  end

  def third_shot_score(next_frame, next_next_frame)
    next_next_frame.nil? ? next_frame.second_shot.score : next_next_frame.first_shot.score
  end

  def strike_score(frame, next_frame)
    frame.score + next_frame.first_shot.score + next_frame.second_shot.score
  end

  def spare_score(frame, next_frame)
    frame.score + next_frame.first_shot.score
  end
end
