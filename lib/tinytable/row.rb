require 'tinytable/constants'

module TinyTable
  class Row
    include Comparable

    def initialize(cells)
      @cells = cells
    end

    def <=>(obj)
      @cells <=> obj
    end

    def empty?
      @cells.nil? || @cells.empty?
    end

    def each_cell_with_index(&block)
      @cells.length.times do |idx|
        block.call(cell_at(idx), idx)
      end
    end

    def cell_at(idx)
      text = @cells.fetch(idx, '')
      Cell.new(text, LEFT_ALIGN)
    end

    def cell_count
      @cells.count
    end

    def map(&block)
      @cells.map(&block)
    end
  end
end
