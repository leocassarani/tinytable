require File.expand_path('../../../lib/tinytable/text_formatter', __FILE__)

describe TinyTable::TextFormatter do
  let(:table) { stub(:table, :has_header? => false, :has_footer? => false) }
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

  it "renders the footer row if the table has one" do
    row1 = %w[Londoners 8294058]
    row2 = %w[Brummies 2293099]
    table.stub(:has_footer?) { true }
    table.stub(:footer) { %w[Total 10587157] }
    table.stub(:each_row).and_yield(row1).and_yield(row2)
    subject.render.should == <<-EOF
+-----------+----------+
| Londoners | 8294058  |
| Brummies  | 2293099  |
+-----------+----------+
| Total     | 10587157 |
+-----------+----------+
    EOF
  end
end
