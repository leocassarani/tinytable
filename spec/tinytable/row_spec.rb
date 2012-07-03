require File.expand_path('../../../lib/tinytable/row', __FILE__)
require File.expand_path('../../../lib/tinytable/cell', __FILE__)

describe TinyTable::Row do
  it "returns cells with the correct alignment" do
    row = TinyTable::Row.new(['a', 'b'], [TinyTable::RIGHT, TinyTable::LEFT])
    row.cell_at(0).should == TinyTable::Cell.new('a', TinyTable::RIGHT)
    row.cell_at(1).should == TinyTable::Cell.new('b', TinyTable::LEFT)
  end

  it "defaults to left alignment unless otherwise specified" do
    row = TinyTable::Row.new(['a'])
    row.cell_at(0).should == TinyTable::Cell.new('a', TinyTable::LEFT)
  end

  it "knows if it's empty" do
    TinyTable::Row.new([]).should be_empty
    TinyTable::Row.new(['a']).should_not be_empty
  end

  it "is equal to another row with the same cells" do
    TinyTable::Row.new(['a']).should == TinyTable::Row.new(['a'])
  end
end
