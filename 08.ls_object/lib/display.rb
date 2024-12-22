# frozen_string_literal: true

class Display
  def initialize(display_data, options)
    @names = display_data[:names]
    @details = display_data[:details]
    @total = display_data[:total]
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
