#!/usr/bin/env ruby
# frozen_string_literal: true

require './shot'
require './frame'
require './game'

def main
  marks = ARGV[0].split(',')
  shots = Shot.new(marks).to_shots
  frames = Frame.new(shots).to_frames
  score = Game.new(frames).to_score
  p score
end

main
