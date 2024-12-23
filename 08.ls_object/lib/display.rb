# frozen_string_literal: true

class Display
  def initialize(display_content, options)
    @names = display_content[:names]
    @details = display_content[:details]
    @total = display_content[:total]
    @show_details = options['l']
  end

  def print
    rows = @show_details ? @details : @names
    puts "total #{@total}" if @show_details && @details.size > 1
    rows.each do |row|
      puts row
    end
  end
end
