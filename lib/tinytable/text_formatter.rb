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

      if @table.has_header?
        hr
        row(@table.header)
      end

      hr
      @table.each_row { |r| row(r) }
      hr

      @output
    end

  private

    def calculate_column_sizes
      @col_widths = if @table.has_header?
        @table.header.map { |cell| cell.to_s.length }
      else
        []
      end

      @table.each_row do |r|
        r.each_with_index do |cell, i|
          max_width = @col_widths[i]
          cell_width = cell.to_s.length

          if max_width.nil? || cell_width > max_width
            @col_widths[i] = cell_width
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
      r.each_with_index { |c, i| cell(c, i) }
      new_line
    end

    def cell(text, i)
      append PADDING
      append text

      cell_width = @col_widths[i]
      text_width = text.to_s.length
      if text_width < cell_width
        append PADDING * (cell_width - text_width)
      end

      append PADDING
      append VERTICAL
    end

    def append(text)
      @output << text.to_s
    end

    def new_line
      append "\n"
    end
  end
end
