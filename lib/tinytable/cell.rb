module TinyTable
  class Cell
    attr_reader :alignment

    def initialize(text, alignment)
      @text = text || ''
      @alignment = alignment
    end

    def text
      @text.to_s
    end
  end
end
