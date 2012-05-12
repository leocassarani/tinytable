require File.expand_path('../../../lib/tinytable', __FILE__)

describe "A Tiny Table" do
  it "supports tables with no header or footer" do
    table = TinyTable.new
    table << ["London", "Greater London"]
    table << ["Birmingham", "West Midlands"]
    table << ["Manchester", "Greater Manchester"]
    table.to_text.should == <<-EOF
+------------+--------------------+
| London     | Greater London     |
| Birmingham | West Midlands      |
| Manchester | Greater Manchester |
+------------+--------------------+
    EOF
  end

  it "supports a header" do
    table = TinyTable.new(%w[City County])
    table << ["Liverpool", "Merseyside"]
    table << ["Newcastle", "Tyne & Wear"]
    table << ["Nottingham", "Nottinghamshire"]
    table.to_text.should == <<-EOF
+------------+-----------------+
| City       | County          |
+------------+-----------------+
| Liverpool  | Merseyside      |
| Newcastle  | Tyne & Wear     |
| Nottingham | Nottinghamshire |
+------------+-----------------+
    EOF
  end

  it "supports a footer" do
    table = TinyTable.new
    table << ["Londoners", 8_294_058]
    table << ["Brummies", 2_293_099]
    table << ["Mancunians", 1_741_961]
    table.footer = ["Total", 12_329_118]
    table.to_text.should == <<-EOF
+------------+----------+
| Londoners  | 8294058  |
| Brummies   | 2293099  |
| Mancunians | 1741961  |
+------------+----------+
| Total      | 12329118 |
+------------+----------+
    EOF
  end

  it "supports both a header and a footer" do
    table = TinyTable.new
    table.header = %w[City County Population]
    table << ["London", "Greater London", 8_294_058]
    table << ["Birmingham", "West Midlands", 2_293_099]
    table << ["Manchester", "Greater Manchester", 1_741_961]
    table.footer = ["Total", nil, 12_329_118]
    table.to_text.should == <<-EOF
+------------+--------------------+------------+
| City       | County             | Population |
+------------+--------------------+------------+
| London     | Greater London     | 8294058    |
| Birmingham | West Midlands      | 2293099    |
| Manchester | Greater Manchester | 1741961    |
+------------+--------------------+------------+
| Total      |                    | 12329118   |
+------------+--------------------+------------+
    EOF
  end

  it "returns an empty string if the table is completely empty" do
    TinyTable.new.to_text.should == ''
  end

  it "correctly handles rows with fewer cells than the rest" do
    table = TinyTable.new("City", "County", "Mayor")
    table.add "London", "Greater London", "Boris Johnson"
    table.add "Sheffield", "Yorkshire"
    table.add "Bristol"
    table.to_text.should == <<-EOF
+-----------+----------------+---------------+
| City      | County         | Mayor         |
+-----------+----------------+---------------+
| London    | Greater London | Boris Johnson |
| Sheffield | Yorkshire      |               |
| Bristol   |                |               |
+-----------+----------------+---------------+
    EOF
  end

  it "supports an alternative syntax based on argument lists" do
    table = TinyTable.new("City", "County", "Population")
    table.add "London", "Greater London", 8_294_058
    table.add "Birmingham", "West Midlands", 2_293_099
    table.add "Manchester", "Greater Manchester", 1_741_961
    table.footer = "Total", nil, 12_329_118
    table.to_text.should == <<-EOF
+------------+--------------------+------------+
| City       | County             | Population |
+------------+--------------------+------------+
| London     | Greater London     | 8294058    |
| Birmingham | West Midlands      | 2293099    |
| Manchester | Greater Manchester | 1741961    |
+------------+--------------------+------------+
| Total      |                    | 12329118   |
+------------+--------------------+------------+
    EOF
  end

  it "supports an alternative syntax based on hashes" do
    table = TinyTable.new('City', 'County', 'Mayor')
    table.add 'City' => "London", 'Mayor' => "Boris Johnson", 'County' => "Greater London"
    table.add 'City' => "Sheffield", 'County' => "Yorkshire"
    table.add 'Mayor' => "Peter Soulsby", 'City' => "Leicester"
    table.to_text.should == <<-EOF
+-----------+----------------+---------------+
| City      | County         | Mayor         |
+-----------+----------------+---------------+
| London    | Greater London | Boris Johnson |
| Sheffield | Yorkshire      |               |
| Leicester |                | Peter Soulsby |
+-----------+----------------+---------------+
    EOF
  end
end
