# frozen_string_literal: true

class LS
  def self.run
    path, options = InputParser.parse.values_at(:path, :options)
    entries = EntriesGenerator.new(path).generate
    entries_after_options = OptionApplier.new(options, entries).apply
    display_content = DisplayContentBuilder.build(entries_after_options)
    Display.new(display_content, options).print
  end
end
