require File.expand_path('../constants', __FILE__)

module TinyTable
  class TextFormatter
    CORNER = '+'
    VERTICAL = '|'
    HORIZONTAL = '-'
    PADDING = ' '

    STRING_ALIGN = {
      LEFT => :ljust,
      CENTER => :center,
      RIGHT => :rjust
    }

    def initialize(table)
      @table = table
      @output = ''
    end

    def render
      clear_output
      precompute_table_layout

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
      if @table.has_rows?
        hr
        @table.each_row { |row| render_row(row) }
        hr
      end
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

      @column_count.times do |i|
        cell = row.cell_at(i)
        render_cell(cell, i)
      end

      new_line
    end

    def render_cell(cell, i)
      append PADDING

      method = STRING_ALIGN[cell.alignment]
      text = cell.text.__send__(method, @column_widths[i], PADDING)
      append text

      append PADDING
      append VERTICAL
    end

    def append(text)
      @output << text.to_s
    end

    def new_line
      append "\n"
    end

    def clear_output
      if RUBY_VERSION < "1.9"
        @output = ''
      else
        @output.clear
      end
    end

    def precompute_table_layout
      layout = Layout.new(@table).analyze
      @column_count = layout.column_count
      @column_widths = layout.max_column_widths
    end
  end
end
