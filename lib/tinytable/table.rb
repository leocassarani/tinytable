module TinyTable
  class Table
    attr_writer :header, :footer
    attr_reader :rows

    def initialize(*args)
      header = args.first.is_a?(Array) ? args.first : args
      @header = header
      @rows = []
      @alignments = []
    end

    def add(*args)
      row = extract_row_args(args)
      rows << row
    end
    alias_method :<<, :add

    def align(column, alignment)
      idx = case column
      when String
        @header.index(column)
      when Fixnum
        column
      else
        raise ArgumentError.new("Received a #{column.class} but expecting a Fixnum or String")
      end
      @alignments[idx] = alignment unless idx.nil?
    end

    def has_header?
      !(header.nil? || header.empty?)
    end

    def has_rows?
      !rows.empty?
    end

    def has_footer?
      !(footer.nil? || footer.empty?)
    end

    def header
      Row.new(@header, @alignments)
    end

    def each_row(&block)
      rows.each do |cells|
        row = Row.new(cells, @alignments)
        block.call(row)
      end
    end

    def footer
      Row.new(@footer, @alignments)
    end

    def to_text
      TinyTable::TextFormatter.new(self).render
    end

    private

    def extract_row_args(args)
      case args.first
      when Array
        args.first
      when Hash
        if has_header?
          header.map { |key| args.first[key] }
        else
          raise ArgumentError.new("Received a Hash but no header row was given")
        end
      else
        args
      end
    end
  end
end
