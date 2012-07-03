require 'forwardable'
require 'tinytable/constants'

module TinyTable
  class Row
    extend Forwardable
    def_delegators :@cells, :empty?, :map

    attr_reader :cells

    def initialize(cells, alignments = [])
      @cells = cells || []
      @alignments = alignments
    end

    def ==(obj)
      return false unless obj.is_a? Row
      @cells == obj.cells
    end

    def cell_count
      @cells.count
    end

    def each_cell_with_index(&block)
      @cells.length.times do |idx|
        block.call(cell_at(idx), idx)
      end
    end

    def cell_at(idx)
      text = @cells.fetch(idx, '')
      alignment = @alignments.fetch(idx, LEFT)
      Cell.new(text, alignment)
    end
  end
end
