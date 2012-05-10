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
    formatter = stub(:formatter, :render => "ASCII table")
    TinyTable::TextFormatter.stub(:new).with(subject) { formatter }
    subject.to_text.should == "ASCII table"
  end

  context "given a header row" do
    let(:header) { %[City County] }

    it "can store and recall a header row" do
      subject.header = header
      subject.header.should == header
    end

    it "doesn't return the header along with regular rows" do
      subject.header = header
      subject << row
      subject.rows.should == [row]
    end
  end

  context "given a footer row" do
    let(:footer) { %w[Total 12329118] }

    it "can store and recall a footer row" do
      subject.footer = footer
      subject.footer.should == footer
    end

    it "doesn't return the footer along with regular rows" do
      subject << row
      subject.footer = footer
      subject.rows.should == [row]
    end
  end
end
