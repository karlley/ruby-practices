#!/usr/bin/env ruby
# frozen_string_literal: true

class Frame
  attr_reader :shot

  def initialize(shots)
    @shots = shots
  end

  def to_frames
    @shots.each_slice(2).to_a
  end
end
