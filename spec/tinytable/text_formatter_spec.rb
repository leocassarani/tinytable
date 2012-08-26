require File.expand_path('../../../lib/tinytable/text_formatter', __FILE__)
require File.expand_path('../../../lib/tinytable/row', __FILE__)
require File.expand_path('../../../lib/tinytable/cell', __FILE__)

module TinyTable
  class Layout ; end
end

describe TinyTable::TextFormatter do
  def make_row(row)
    TinyTable::Row.new(row)
  end

  let(:table) { mock(:table, :has_header? => false,
                             :has_rows? => true,
                             :has_footer? => false) }
  let(:layout) { mock(:layout, :column_count => 2) }
  let(:formatter) { TinyTable::TextFormatter.new(table) }
  before do
    layout.stub(:analyze) { layout }
    TinyTable::Layout.stub(:new).with(table) { layout }
  end

  it "formats a TinyTable as an ASCII table" do
    table.stub(:each_row).and_yield(make_row %w[Liverpool Merseyside])
    layout.stub(:max_column_widths) { ["Liverpool".length, "Merseyside".length] }
    formatter.render.should == <<-EOF
+-----------+------------+
| Liverpool | Merseyside |
+-----------+------------+
    EOF
  end

  it "adjusts the width of the table to fit the largest row" do
    row1 = make_row %w[Liverpool Merseyside]
    row2 = make_row %w[Nottingham Nottinghamshire]
    table.stub(:each_row).and_yield(row1).and_yield(row2)
    layout.stub(:max_column_widths) { ["Nottingham".length, "Nottinghamshire".length] }
    formatter.render.should == <<-EOF
+------------+-----------------+
| Liverpool  | Merseyside      |
| Nottingham | Nottinghamshire |
+------------+-----------------+
    EOF
  end

  it "renders the header row if the table has one" do
    table.stub(:has_header?) { true }
    table.stub(:header) { make_row %w[City County] }
    table.stub(:each_row).and_yield(make_row %w[Southampton Hampshire])
    layout.stub(:max_column_widths) { ["Southampton".length, "Hampshire".length] }

    formatter.render.should == <<-EOF
+-------------+-----------+
| City        | County    |
+-------------+-----------+
| Southampton | Hampshire |
+-------------+-----------+
    EOF
  end

  it "renders the footer row if the table has one" do
    row1 = make_row %w[Londoners 8294058]
    row2 = make_row %w[Brummies 2293099]

    table.stub(:has_footer?) { true }
    table.stub(:footer) { make_row %w[Total 10587157] }
    table.stub(:each_row).and_yield(row1).and_yield(row2)

    layout.stub(:max_column_widths) { ["Londoners".length, "10587157".length] }
    formatter.render.should == <<-EOF
+-----------+----------+
| Londoners | 8294058  |
| Brummies  | 2293099  |
+-----------+----------+
| Total     | 10587157 |
+-----------+----------+
    EOF
  end

  it "renders empty cells if a row has fewer columns than the rest" do
    row1 = make_row ["London", "Greater London", "Boris Johnson"]
    row2 = make_row ["Sheffield", "Yorkshire"]
    table.stub(:each_row).and_yield(row1).and_yield(row2)

    layout.stub(:max_column_widths) { ["Sheffield".length, "Greater London".length, "Boris Johnson".length] }
    layout.stub(:column_count) { 3 }

    formatter.render.should == <<-EOF
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
    formatter.render.should == ''
  end
end
