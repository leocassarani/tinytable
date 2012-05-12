require File.expand_path('../../../lib/tinytable/text_formatter', __FILE__)

module TinyTable
  class Layout ; end
end

describe TinyTable::TextFormatter do
  let(:table) { stub(:table, :has_header? => false, :has_rows? => true, :has_footer? => false) }
  let(:layout) { stub(:layout, :column_count => 2) }
  before { TinyTable::Layout.stub(:new).with(table) { layout } }
  subject { TinyTable::TextFormatter.new(table) }

  it "formats a TinyTable as an ASCII table" do
    table.stub(:each_row).and_yield(%w[Liverpool Merseyside])
    layout.stub(:max_column_widths) { ["Liverpool".length, "Merseyside".length] }
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
    layout.stub(:max_column_widths) { ["Nottingham".length, "Nottinghamshire".length] }
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
    layout.stub(:max_column_widths) { ["Southampton".length, "Hampshire".length] }

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

    layout.stub(:max_column_widths) { ["Londoners".length, "10587157".length] }
    subject.render.should == <<-EOF
+-----------+----------+
| Londoners | 8294058  |
| Brummies  | 2293099  |
+-----------+----------+
| Total     | 10587157 |
+-----------+----------+
    EOF
  end

  it "renders empty cells if a row has fewer columns than the rest" do
    row1 = ["London", "Greater London", "Boris Johnson"]
    row2 = ["Sheffield", "Yorkshire"]
    table.stub(:each_row).and_yield(row1).and_yield(row2)

    layout.stub(:max_column_widths) { ["Sheffield".length, "Greater London".length, "Boris Johnson".length] }
    layout.stub(:column_count) { 3 }

    subject.render.should == <<-EOF
+-----------+----------------+---------------+
| London    | Greater London | Boris Johnson |
| Sheffield | Yorkshire      |               |
+-----------+----------------+---------------+
    EOF
  end

  it "returns an empty string if the table is completely empty" do
    table.stub(:has_rows?) { false }
    layout.stub(:max_column_widths) { [] }
    layout.stub(:column_count) { 0 }
    subject.render.should == ''
  end
end
