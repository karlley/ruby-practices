#!/usr/bin/env ruby
# frozen_string_literal: true

require './game'

def main
  total_score = Game.new.calculate_total_score
  p total_score
end

main
