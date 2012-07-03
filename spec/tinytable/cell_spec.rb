require File.expand_path('../../../lib/tinytable/cell', __FILE__)
require File.expand_path('../../../lib/tinytable/constants', __FILE__)

describe TinyTable::Cell do
  it "converts numbers to strings" do
    TinyTable::Cell.new(123, TinyTable::LEFT).text.should == "123"
  end

  it "returns an empty string if its text was initialized as nil" do
    TinyTable::Cell.new(nil, TinyTable::LEFT).text.should == ''
  end

  it "is equal to another cell with same text and alignment" do
    a1 = TinyTable::Cell.new('a', TinyTable::LEFT)
    a2 = TinyTable::Cell.new('a', TinyTable::LEFT)
    a1.should == a2
  end

  it "is different from another cell with different text or alignment" do
    a = TinyTable::Cell.new('a', TinyTable::LEFT)
    b = TinyTable::Cell.new('b', TinyTable::LEFT)
    a.should_not == b
  end
end
