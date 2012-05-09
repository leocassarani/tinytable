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
      render_header
      render_rows
      render_footer
      @output
    end

  private

    def render_header
      if @table.has_header?
        hr
        render_row(@table.header)
      end
    end

    def render_rows
      hr
      @table.each_row { |row| render_row(row) }
      hr
    end

    def render_footer
      if @table.has_footer?
        render_row(@table.footer)
        hr
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

    def render_row(row)
      append VERTICAL
      row.each_with_index { |cell, i| render_cell(cell, i) }
      new_line
    end

    def render_cell(text, i)
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

      if @table.has_footer?
        @table.footer.each_with_index do |cell, i|
          max_width = @col_widths[i]
          cell_width = cell.to_s.length

          if max_width.nil? || cell_width > max_width
            @col_widths[i] = cell_width
          end
        end
      end
    end
  end
end
