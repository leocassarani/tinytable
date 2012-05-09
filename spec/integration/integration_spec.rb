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

  it "supports a footer"
end
