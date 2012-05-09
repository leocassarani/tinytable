require File.expand_path('../../../lib/tinytable/text_formatter', __FILE__)

describe TinyTable::TextFormatter do
  let(:table) { stub(:table, :has_header? => false) }
  subject { TinyTable::TextFormatter.new(table) }

  it "formats a TinyTable as an ASCII table" do
    table.stub(:each_row).and_yield(%w[Liverpool Merseyside])
    subject.render.should == <<-EOF
+-----------+------------+
| Liverpool | Merseyside |
+-----------+------------+
    EOF
  end

  it "adjusts the width of the table to fit the largest row" do
    row1 = %w[Liverpool Merseyside]
    row2 = %w[Nottingham Nottinghamshire]
    table.stub(:each_row).and_yield(row1).and_yield(row2)
    subject.render.should == <<-EOF
+------------+-----------------+
| Liverpool  | Merseyside      |
| Nottingham | Nottinghamshire |
+------------+-----------------+
    EOF
  end

  it "correctly calculates the width of a cell containing an integer" do
    row1 = ["London", 8_294_058]
    row2 = ["Bristol", 558_566]
    table.stub(:each_row).and_yield(row1).and_yield(row2)
    subject.render.should == <<-EOF
+---------+---------+
| London  | 8294058 |
| Bristol | 558566  |
+---------+---------+
    EOF
  end

  it "renders the header row if the table has one" do
    table.stub(:has_header?) { true }
    table.stub(:header) { %w[City County] }
    table.stub(:each_row).and_yield(%w[Southampton Hampshire])
    subject.render.should == <<-EOF
+-------------+-----------+
| City        | County    |
+-------------+-----------+
| Southampton | Hampshire |
+-------------+-----------+
    EOF
  end
end
