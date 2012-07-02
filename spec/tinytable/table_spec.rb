require File.expand_path('../../../lib/tinytable/table', __FILE__)
require File.expand_path('../../../lib/tinytable/row', __FILE__)
require File.expand_path('../../../lib/tinytable/cell', __FILE__)

module TinyTable
  class TextFormatter ; end
end

describe TinyTable::Table do
  let(:table) { TinyTable::Table.new }
  let(:row) { %w[Liverpool Merseyside] }

  it "stores and recalls rows" do
    table << row
    table.rows.should == [row]
  end

  it "exposes an iterator over the rows" do
    table << row
    row_obj = stub(:row_obj)
    TinyTable::Row.stub(:new).with(row) { row_obj }
    table.each_row do |r|
      r.should == row_obj
    end
  end

  it "knows whether it contains any rows" do
    table.should_not have_rows
    table << row
    table.should have_rows
  end

  it "uses a TextFormatter to render an ASCII representation of the table" do
    formatter = stub(:formatter, :render => "ASCII table")
    TinyTable::TextFormatter.stub(:new).with(table) { formatter }
    table.to_text.should == "ASCII table"
  end

  it "stores and recalls a header row" do
    table.header = ["City", "County"]
    table.header.should == ["City", "County"]
  end

  it "doesn't return the header along with regular rows" do
    table.header = ["City", "County"]
    table << row
    table.rows.should == [row]
  end

  it "stores and recalls a footer row" do
    table.footer = ["Total", "123.45"]
    table.footer.should == ["Total", "123.45"]
  end

  it "doesn't return the footer along with regular rows" do
    table << row
    table.footer = ["Total", "123.45"]
    table.rows.should == [row]
  end

  it "supports a number of different ways to add new rows" do
    table.add "London", "Greater London"
    table.add ["Birmingham", "West Midlands"]
    table << ["Manchester", "Greater Manchester"]
    table.rows.should == [
      ["London", "Greater London"],
      ["Birmingham", "West Midlands"],
      ["Manchester", "Greater Manchester"]
    ]
  end

  it "supports a number of different ways to set the header" do
    table.header = ["City", "County"]
    table.header.should == ["City", "County"]

    table.header = "City", "County"
    table.header.should == ["City", "County"]

    table = TinyTable::Table.new("City", "County")
    table.header.should == ["City", "County"]

    table = TinyTable::Table.new ["City", "County"]
    table.header.should == ["City", "County"]
  end

  it "supports a number of different ways to set the footer" do
    table.footer = ["Total", "300"]
    table.footer.should == ["Total", "300"]

    table.footer = "Total", "300"
    table.footer.should == ["Total", "300"]
  end

  it "allows a row to be entered as a hash with header titles as its keys" do
    table.header = "City", "County", "Population"
    table.add 'City' => "Reading", 'Population' => 373_836, 'County' => "Berkshire"
    table << { 'County' => "Hampshire", 'City' => "Winchester" }
    table.rows.should == [
      ["Reading", "Berkshire", 373_836],
      ["Winchester", "Hampshire", nil]
    ]
  end

  it "raises an ArgumentError if a hash is given without a header row" do
    lambda {
      table.add 'City' => "Reading", 'County' => "Berkshire"
    }.should raise_error(ArgumentError)
  end
end
