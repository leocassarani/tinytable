module TinyTable
  class Layout
    attr_reader :column_count, :max_column_widths

    def initialize(table)
      @table = table
      analyze_table_layout
    end

  private

    def analyze_table_layout
      @column_count = 0
      @max_column_widths = []

      analyze_header
      analyze_rows
      analyze_footer
    end

    def analyze_header
      if @table.has_header?
        analyze_row(@table.header)
      end
    end

    def analyze_rows
      if @table.has_rows?
        @table.each_row do |row|
          analyze_row(row)
        end
      end
    end

    def analyze_footer
      if @table.has_footer?
        analyze_row(@table.footer)
      end
    end

    def analyze_row(row)
      if row.count > @column_count
        @column_count = row.count
      end

      row.each_with_index do |cell, i|
        analyze_cell(cell, i)
      end
    end

    def analyze_cell(cell, i)
      @max_column_widths[i] ||= 0
      max_width = @max_column_widths[i]
      cell_width = cell.to_s.length

      if cell_width > max_width
        @max_column_widths[i] = cell_width
      end
    end
  end
end
