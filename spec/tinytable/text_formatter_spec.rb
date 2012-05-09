require File.expand_path('../../../lib/tinytable/text_formatter', __FILE__)

describe TinyTable::TextFormatter do
  let(:table) { stub(:table) }
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
end
