require "tinytable/version"
require "tinytable/text_formatter"

class TinyTable
  attr_reader :rows

  def initialize
    @rows = []
  end

  def <<(row)
    @rows << row
  end

  def each_row(&block)
    @rows.each(&block)
  end

  def to_text
    formatter = TinyTable::TextFormatter.new(self)
    formatter.render
  end
end
