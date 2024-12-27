# frozen_string_literal: true

class Input
  def initialize
    args = parse_input
    @options = args[:options]
    @path = args[:path]
    @entry_names = fetch_entry_names(@path)
  end

  attr_reader :path, :options, :entry_names

  private

  def parse_input
    options = ARGV.getopts('arl')
    path = ARGV[0] || Dir.getwd
    { path:, options: }
  end

  def fetch_entry_names(path)
    return [path] unless File.directory?(path)

    Dir.glob('*', File::FNM_DOTMATCH, base: path)
  end
end
