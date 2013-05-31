require File.expand_path('../../../lib/tinytable/layout', __FILE__)
require File.expand_path('../../../lib/tinytable/row', __FILE__)
require File.expand_path('../../../lib/tinytable/cell', __FILE__)

describe TinyTable::Layout do
  let(:table) { mock(:table, :has_header? => false, :has_rows? => true, :has_footer? => false) }
  let(:layout) { TinyTable::Layout.new(table).analyze }

  it "knows how many columns a table has" do
    row1 = TinyTable::Row.new(["One"])
    row2 = TinyTable::Row.new(["One", "Two"])
    row3 = TinyTable::Row.new(["One", "Two", "Three"])
    table.stub(:each_row).and_yield(row1).and_yield(row2).and_yield(row3)
    layout.column_count.should == 3
  end

  it "knows the maximum width for each column in the table" do
    row1 = TinyTable::Row.new(["123", "1", "12"])
    row2 = TinyTable::Row.new(["12345", "123", "1"])
    row3 = TinyTable::Row.new(["1234567", "12", "1"])
    table.stub(:each_row).and_yield(row1).and_yield(row2).and_yield(row3)
    layout.max_column_widths.should == [7, 3, 2]
  end

  it "includes the header row when calculating maximum column widths" do
    table.stub(:has_header?) { true }
    table.stub(:header) { TinyTable::Row.new(["12345", "1"]) }
    table.stub(:each_row).and_yield(TinyTable::Row.new(["123", "12"]))
    layout.max_column_widths.should == [5, 2]
  end

  it "includes the footer row when calculating maximum column widths" do
    table.stub(:has_footer?) { true }
    table.stub(:footer) { TinyTable::Row.new(["123", "12345"]) }
    table.stub(:each_row).and_yield(TinyTable::Row.new(["1234", "12"]))
    layout.max_column_widths.should == [4, 5]
  end

  it "correctly calculates the width of cells containing an integer" do
    row1 = TinyTable::Row.new(["London", 8_294_058])
    row2 = TinyTable::Row.new(["Liverpool", 830_112])
    table.stub(:each_row).and_yield(row1).and_yield(row2)
    layout.max_column_widths.should == [9, 7]
  end

  it "correctly deals with completely empty tables" do
    table.stub(:has_rows?) { false }
    layout.max_column_widths.should eq []
    layout.column_count.should be_zero
  end
end
