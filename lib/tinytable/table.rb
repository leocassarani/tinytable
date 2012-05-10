module TinyTable
  class Table
    attr_accessor :header, :footer
    attr_reader :rows

    def initialize(*args)
      header = args.first.is_a?(Array) ? args.first : args
      @header = header
      @rows = []
    end

    def add(*args)
      row = args.first.is_a?(Array) ? args.first : args
      rows << row
    end
    alias_method :<<, :add

    def has_header?
      !(header.nil? || header.empty?)
    end

    def has_footer?
      !(footer.nil? || footer.empty?)
    end

    def each_row(&block)
      rows.each(&block)
    end

    def to_text
      formatter = TinyTable::TextFormatter.new(self)
      formatter.render
    end
  end
end
