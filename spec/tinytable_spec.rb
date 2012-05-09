require File.expand_path('../../lib/tinytable', __FILE__)

class TinyTable
  class TextFormatter ; end
end

describe TinyTable do
  subject { TinyTable.new }
  let(:row) { %[Liverpool Merseyside] }

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
    formatter = stub(:render => "ASCII table")
    TinyTable::TextFormatter.stub(:new).with(subject) { formatter }
    subject.to_text.should == "ASCII table"
  end
end
