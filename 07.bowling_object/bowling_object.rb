#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

inputs = ARGV[0].split(',')
puts Game.new(inputs).total_score
