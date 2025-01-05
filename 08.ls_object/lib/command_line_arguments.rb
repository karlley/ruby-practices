# frozen_string_literal: true

class CommandLineArguments
  def initialize(argv = ARGV)
    args = parse(argv)
    @options = args[:options]
    @path = args[:path]
  end

  attr_reader :options, :path

  private

  def parse(argv)
    options = argv.getopts('arl')
    path = argv[0] || Dir.getwd
    { path:, options: }
  end
end
