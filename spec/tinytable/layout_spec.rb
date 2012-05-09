require File.expand_path('../../../lib/tinytable/layout', __FILE__)

describe TinyTable::Layout do
  let(:table) { stub(:table, :has_header? => false, :has_footer? => false) }
  subject { TinyTable::Layout.new(table) }

  it "knows how many columns a table has" do
    row1 = ["One"]
    row2 = ["One", "Two"]
    row3 = ["One", "Two", "Three"]
    table.stub(:each_row).and_yield(row1).and_yield(row2).and_yield(row3)
    subject.column_count.should == 3
  end

  it "knows the maximum width for each column in the table" do
    row1 = ["123", "1", "12"]
    row2 = ["12345", "123", "1"]
    row3 = ["1234567", "12", "1"]
    table.stub(:each_row).and_yield(row1).and_yield(row2).and_yield(row3)
    subject.max_column_widths.should == [7, 3, 2]
  end

  it "includes the header row when calculating maximum column widths" do
    table.stub(:has_header?) { true }
    table.stub(:header) { ["12345", "1"] }
    table.stub(:each_row).and_yield(["123", "12"])
    subject.max_column_widths.should == [5, 2]
  end

  it "includes the footer row when calculating maximum column widths" do
    table.stub(:has_footer?) { true }
    table.stub(:footer) { ["123", "12345"] }
    table.stub(:each_row).and_yield(["1234", "12"])
    subject.max_column_widths.should == [4, 5]
  end

  it "correctly calculates the width of cells containing an integer" do
    row1 = ["London", 8_294_058]
    row2 = ["Liverpool", 830_112]
    table.stub(:each_row).and_yield(row1).and_yield(row2)
    subject.max_column_widths.should == [9, 7]
  end
end
