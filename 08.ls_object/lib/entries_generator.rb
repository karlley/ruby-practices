# frozen_string_literal: true

class EntriesGenerator
  def initialize(path)
    @path = path
  end

  def generate
    entry_names.map do |name|
      Entry.new(name, full_path(name))
    end
  end

  private

  def entry_names
    return [@path] unless File.directory?(@path)

    Dir.glob('*', File::FNM_DOTMATCH, base: @path)
  end

  def full_path(name)
    File.directory?(@path) ? File.join(@path, name) : name # カレントディレクトリ以外のパス指定で必要
  end
end
