# frozen_string_literal: true

class Shot
  def initialize(shot)
    @shot = shot
  end

  def to_score
    @shot == 'X' ? [10, 0] : @shot.to_i
  end
end
