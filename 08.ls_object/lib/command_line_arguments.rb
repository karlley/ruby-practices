# frozen_string_literal: true

class CommandLineArguments
  def initialize(argv = ARGV)
    @args = parse(argv)
  end

  def options
    @args[:options]
  end

  def path
    @args[:path]
  end

  private

  def parse(argv)
    options = argv.getopts('arl')
    path = argv[0] || Dir.getwd
    { path:, options: }
  end
end
