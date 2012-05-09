class TinyTable
  class TextFormatter
    CORNER = '+'
    VERTICAL = '|'
    HORIZONTAL = '-'
    PADDING = ' '

    def initialize(table)
      @table = table
      @output = ''
    end

    def render
      @output.clear
      calculate_column_sizes

      hr
      @table.each_row { |r| row(r) }
      hr

      @output
    end

  private

    def calculate_column_sizes
      @col_widths = []
      @table.each_row do |r|
        r.each_with_index do |col, i|
          if @col_widths[i].nil? || col.length > @col_widths[i]
            @col_widths[i] = col.length
          end
        end
      end
    end

    def hr
      append CORNER
      @col_widths.each do |w|
        append HORIZONTAL * (w + 2)
        append CORNER
      end
      new_line
    end

    def row(r)
      append VERTICAL
      r.each_with_index { |c, i| col(c, i) }
      new_line
    end

    def col(text, i)
      append PADDING
      append text
      width = @col_widths[i]
      if text.length < width
        append PADDING * (width - text.length)
      end
      append PADDING
      append VERTICAL
    end

    def append(text)
      @output << text
    end

    def new_line
      append "\n"
    end
  end
end
