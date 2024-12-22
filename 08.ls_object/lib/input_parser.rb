# frozen_string_literal: true

class InputParser
  def self.parse
    options = ARGV.getopts('arl')
    path = ARGV[0] || Dir.getwd
    { path:, options: }
  end
end
