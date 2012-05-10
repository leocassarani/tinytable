require "tinytable/version"
require "tinytable/table"
require "tinytable/text_formatter"
require "tinytable/layout"

module TinyTable
  def self.new(*args)
    TinyTable::Table.new(*args)
  end
end
