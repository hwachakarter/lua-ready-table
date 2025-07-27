# lua-ready-table
Create tables as objects in lua! (Batteries included)

## Features:
* Create smart tables with useful methods such as:
* * print() - prints out your table nicely
* * concat(sep, mode) - smarter concat that can output even dicts!
* * remove(to_remove) - smarter remove that supports keys too
* * type() - returns if a table is an array, a dict or combined
* * len() - returns absolute length of a table (including named keys and index values)
* * Also includes sort(), move(), insert() and unpack() from the standard table library.
* Create arrays and dictionaries (locks down creation of unwanted values)

## Dependencies
**None!** Use it in your projects as is. Tested on Lua 5.4

## Usage
1. Place it in your project.
2. Import library as rt for convenience.
```lua
rt = require ( 'ready_table' )
-- assuming library was placed in the same directory as main.lua
```
3. You can create a smart table adding `rt.create` before defining the table. Use `rt.create_array` and `rt.create_dict` to create an array or a dict respectively.
```lua
local my_table = rt.create {}
local my_array = ft.create_array {}
local my_dict = ft.create_dict {}
```
4. Use provided methods right from your table!
``` lua
my_table:insert('Hello')
my_table:print()
```

### Method list
1. `print(no_new_line)` - prints your table formatted in multiline, one key at a time (if dict). Prints arrays in one line. Prints out nested tables too if they are also ready tables. `no_new_line` defaults to `false`, doesn't create a new line at the end if `true`.
2. `concat(sep, mode)` - concats the table based on `mode` and returns a string. Separates each item with `sep` (default = `', '`). 

    Modes include:
    * `array` (default) - returns a string only with number indexed values, ignoring others.
    * `dict` - returns a string of keys and values as `key = value`, ignoring others.
    * `table` - returns a string containing all indexes.
    * `as_dict` - returns a string containing all indexes, number indexes are returned as `index = value`

3. `remove(index)` - now supports string indexes! Removes value by key or index.
4. `len()` - returns absolute length of a table, icluding both named and numbered indexes.
5. `type()` - returns table's type based on it's contents: `array` if only numbered indexes are found, `dict` if only named indexes, `combined` if both.
6. `insert` - same as `table.insert`
7. `sort` - same as `table.sort`
8. `unpack` - sam as `table.unpack`
9. `move` - same as `table.move`

