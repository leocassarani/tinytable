# TinyTable

TinyTable is a Ruby gem that lets you create and output simple ASCII tables with minimal effort. It draws heavy inspiration from [Ruport](https://github.com/ruport/ruport) but, unlike Ruport, it has a very simple and focused API, and no external dependencies.

TinyTable is particularly well-suited to formatting the results of a Rake task or test suite. The output of `rake stats` is a perfect example of the kind of thing you might choose to use TinyTable for.

## Installation

Add this line to your application's Gemfile:

    gem 'tinytable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinytable

## Usage

Create a `TinyTable::Table` and start adding rows to it:

    table = TinyTable::Table.new
    table << ["Controllers", 169, 140]
    table << ["Helpers", 48, 43]
    table << ["Models", 149, 120]
    puts table.to_text

This will output:

    +-------------+-----+-----+
    | Controllers | 169 | 140 |
    | Helpers     | 48  |  43 |
	| Models      | 149 | 120 |
	+-------------+-----+-----+

By default, columns are left-aligned. However, you can specify the text alignment of each column by using its index (starting from 0):

	table.align(0, TinyTable::CENTER)
	table.align(1, TinyTable::RIGHT)
	table.align(2, TinyTable::LEFT)

Output:

	+-------------+-----+-----+
	| Controllers | 169 | 140 |
	|   Helpers   |  48 | 43  |
	|   Models    | 149 | 120 |
	+-------------+-----+-----+

### Headers and Footers

Tables can have headers and footers:

	table = TinyTable::Table.new

	table.header = %w[Name Lines LOC]
	table << ["Controllers", 169, 140]
	table << ["Helpers", 48, 43]
	table.footer = ["Total", 217, 183]

	table.align(1, TinyTable::RIGHT)
	table.align(2, TinyTable::RIGHT)

	puts table.to_text

Output:

	+-------------+-------+-----+
	| Name        | Lines | LOC |
	+-------------+-------+-----+
	| Controllers |   169 | 140 |
	| Helpers     |    48 |  43 |
	+-------------+-------+-----+
	| Total       |   217 | 183 |
	+-------------+-------+-----+

Header titles can also be passed into the constructor for the table.

When a table has a header, new rows can be added as hashes, and columns can be referred to by their header title when specifying text alignment:

	table = TinyTable::Table.new("City", "County")
	table.add "City" => "London", "County" => "Greater London"
	table.add "County" => "Yorkshire", "City" => "Sheffield"
	table.align("County", TinyTable::RIGHT)
	puts table.to_text

Output:

	+-----------+----------------+
	| City      |         County |
	+-----------+----------------+
	| London    | Greater London |
	| Sheffield |      Yorkshire |
	+-----------+----------------+

### Partial Rows

Rows can contain empty cells. When supplying an array, you can use `nil` to skip a column, or you can simply supply a smaller array if you want to skip the columns at the end. When using the hash syntax with header titles, just omit the value for the keys you wish to skip.

	table = TinyTable::Table.new("City", "County")
	table.add [nil, "Shropshire"]
	table.add ["Sheffield"]
	table.add "City" => "Bristol"
	puts table.to_text

Output:

	+-----------+------------+
	| City      | County     |
	+-----------+------------+
	|           | Shropshire |
	| Sheffield |            |
	| Bristol   |            |
	+-----------+------------+

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Leo Cassarani. See [LICENSE](https://github.com/leocassarani/tinytable/blob/master/LICENSE) for details.
