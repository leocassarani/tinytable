module TinyTable
  class Cell
    attr_reader :alignment

    def initialize(text, alignment)
      @text = text || ''
      @alignment = alignment
    end

    def ==(obj)
      return false unless obj.is_a? Cell
      @text == obj.text &&
        @alignment == obj.alignment
    end

    def text
      @text.to_s
    end

    def width
      text.length
    end
  end
end
