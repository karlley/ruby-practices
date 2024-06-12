# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(inputs)
    frame_marks = split_to_frame_marks(inputs)
    @frames = frame_marks.map { |marks| Frame.new(marks) }
  end

  def total_score
    frame_scores = @frames.each_with_index.map do |frame, index|
      if index <= 8
        if double_strike?(frame, index)
          double_strike_score(frame, index)
        elsif strike?(frame)
          strike_score(frame, index)
        elsif spare?(frame)
          spare_score(frame, index)
        else
          frame.score
        end
      else
        frame.score
      end
    end
    frame_scores.sum
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

  def double_strike?(frame, index)
    frame.first_shot.score == 10 && @frames[index + 1].first_shot.score == 10
  end

  def strike?(frame)
    frame.first_shot.score == 10
  end

  def spare?(frame)
    frame.score == 10
  end

  # 次の2投球を加算
  def double_strike_score(frame, index)
    frame.score + @frames[index + 1].first_shot.score + next_frame_score(index)
  end

  # 9フレーム: 次のフレーム2投目
  # 1-8フレーム: 次の次のフレームの投球
  def next_frame_score(index)
    if index == 8
      @frames[index + 1].second_shot.score
    else
      @frames[index + 2].first_shot.score
    end
  end

  # 次のフレームの2投球を加算
  def strike_score(frame, index)
    frame.score + @frames[index + 1].first_shot.score + @frames[index + 1].second_shot.score
  end

  # 次の投球を加算
  def spare_score(frame, index)
    frame.score + @frames[index + 1].first_shot.score
  end
end
