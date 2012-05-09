require "tinytable/version"
require "tinytable/text_formatter"

class TinyTable
  attr_reader :header, :rows
  attr_accessor :footer

  def initialize(header = nil)
    @header = header
    @rows = []
  end

  def <<(row)
    rows << row
  end

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
