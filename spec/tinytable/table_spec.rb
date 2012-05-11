require File.expand_path('../../../lib/tinytable/table', __FILE__)

module TinyTable
  class TextFormatter ; end
end

describe TinyTable::Table do
  subject { TinyTable::Table.new }
  let(:row) { %w[Liverpool Merseyside] }

  it "can store and recall rows" do
    subject << row
    subject.rows.should == [row]
  end

  it "exposes an iterator over the rows" do
    subject << row
    subject.each_row do |r|
      r.should == row
    end
  end

  it "uses a TextFormatter to output an ASCII table" do
    formatter = stub(:formatter, :render => "ASCII table")
    TinyTable::TextFormatter.stub(:new).with(subject) { formatter }
    subject.to_text.should == "ASCII table"
  end

  it "can store and recall a header row" do
    subject.header = ["City", "County"]
    subject.header.should == ["City", "County"]
  end

  it "doesn't return the header along with regular rows" do
    subject.header = ["City", "County"]
    subject << row
    subject.rows.should == [row]
  end

  it "can store and recall a footer row" do
    subject.footer = ["Total", "123.45"]
    subject.footer.should == ["Total", "123.45"]
  end

  it "doesn't return the footer along with regular rows" do
    subject << row
    subject.footer = ["Total", "123.45"]
    subject.rows.should == [row]
  end

  it "supports a number of different ways to add new rows" do
    subject.add "London", "Greater London"
    subject.add ["Birmingham", "West Midlands"]
    subject << ["Manchester", "Greater Manchester"]
    subject.rows.should == [
      ["London", "Greater London"],
      ["Birmingham", "West Midlands"],
      ["Manchester", "Greater Manchester"]
    ]
  end

  it "supports a number of different ways to set the header" do
    subject.header = ["City", "County"]
    subject.header.should == ["City", "County"]

    subject.header = "City", "County"
    subject.header.should == ["City", "County"]

    subject = TinyTable::Table.new("City", "County")
    subject.header.should == ["City", "County"]

    subject = TinyTable::Table.new ["City", "County"]
    subject.header.should == ["City", "County"]
  end

  it "supports a number of different ways to set the footer" do
    subject.footer = ["Total", "300"]
    subject.footer.should == ["Total", "300"]

    subject.footer = "Total", "300"
    subject.footer.should == ["Total", "300"]
  end

  it "allows a row to be entered as a hash with header titles as its keys" do
    subject.header = "City", "County", "Population"
    subject.add 'City' => "Reading", 'Population' => 373_836, 'County' => "Berkshire"
    subject << { 'County' => "Hampshire", 'City' => "Winchester" }
    subject.rows.should == [
      ["Reading", "Berkshire", 373_836],
      ["Winchester", "Hampshire", nil]
    ]
  end
end
