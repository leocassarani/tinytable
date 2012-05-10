module TinyTable
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
      precompute_column_widths

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
      @column_widths.each do |w|
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

      cell_width = @column_widths[i]
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

    def precompute_column_widths
      layout = Layout.new(@table)
      @column_widths = layout.max_column_widths
    end
  end
end
