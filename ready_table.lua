-- A library to create tables, arrays or dictionaries as objects
-- with batteries
-- version: 0.2
local ready_table = {}

local meta_index = {
    __ready_table = true,
    insert = table.insert,
    sort = table.sort,
    unpack = table.unpack,
    move = table.move,
    -- print
    -- concat
    -- remove
    -- len
    -- type
}

-- Writes spaces to console for the print function
local function double_space_times(times)
    for i = 1, times do
        io.write('  ')
    end
end

-- Returns absolute length of a table, inclding named indexes
function meta_index:len()
    local len = 0
    for k, v in pairs(self) do
        len = len + 1
    end
    return len
end

-- Prints table in a line, including named indexes.
-- no_new_line (default - false) creates a new line afterwards or no
-- nest determinates how nested the table is (don't change it)
function meta_index:print(no_new_line, nest)
    no_new_line = no_new_line or false
    nest = nest or 0
    io.write('{ ')
    if #self == 0 then
        io.write('\n')
        double_space_times(nest + 1)
    end
    -- absolute length of a table
    local len = self:len()
    -- show current iteration to catch the last one
    local iteration = 0
    for k, v in pairs(self) do
        iteration = iteration + 1
        -- if we are working with a numbered index
        if tonumber(k) then
            -- not strings are not enclosed in ""
            if type(v) == "string" then
                io.write('"' .. tostring(v) .. '"')
            elseif type(v) == "table" then
                if v.__ready_table then
                    v:print(true, nest + 1)
                else
                    io.write(tostring(v))
                end
            else
                io.write(tostring(v))
            end
        else
            -- not strings are not enclosed in ""
            if type(v) == "string" then
                io.write(k .. ' = "' .. tostring(v) .. '"')
            elseif type(v) == "table" then
                if v.__ready_table then
                    io.write(k .. ' = ')
                    v:print(true, nest + 1)
                else
                    io.write(k .. " = " .. tostring(v))
                end
            else
                io.write(k .. " = " .. tostring(v))
            end
        end
        -- if it is a last iteration, close off
        if iteration == len then
            -- if no named indexes
            if #self == self:len() then
                io.write(' }')
            else
                io.write('\n')
                double_space_times(nest)
                io.write('}')
            end
            -- create new line if no_new_line set to false
            if not no_new_line then
                io.write('\n')
            end
        elseif iteration > #self - 1 then
            -- when it iterates through named indexes
            io.write(',\n  ')
            double_space_times(nest)
        else
            io.write(', ')
        end
    end
end

-- Removes data by index, accepts named indexes
function meta_index:remove(to_remove)
    -- numbered index
    if tonumber(to_remove) then
        table.remove(self, to_remove)
        -- named index
    elseif type(to_remove) == "string" then
        self[to_remove] = nil
    else
        -- raise an error if got something else.
        error("Must be a number or a string.")
    end
end

-- Returns type of a table based on its contents.
-- "array" if no named indexes
-- "dict" if no numbered indexes
-- "combined" if both
function meta_index:type()
    if #self == self:len() then
        return "array"
    elseif (#self == 0) and (self:len() ~= 0) then
        return "dict"
    else
        return "combined"
    end
end

-- Concats a table in a string and returns it.
-- Parameters:
-- sep (default - ", ") - separator between values
-- mode (default - "array") - determines what to concat
-- * "array" - concats numbered indexes
-- * "dict" - concats named indexes
-- * "table" - concats all
-- * "as_dict" - concats all, numbered indexes are also concated as named
function meta_index:concat(sep, mode)
    sep = sep or ', '
    mode = mode or "array"
    local str = ''
    if mode == "array" then
        for k, v in ipairs(self) do
            str = str .. tostring(v) .. sep
        end
    elseif mode == "as_dict" then
        for k, v in pairs(self) do
            if type(v) == "string" then
                str = str .. k .. ' = "' .. tostring(v) .. '"' .. sep
            else
                str = str .. k .. ' = ' .. tostring(v) .. sep
            end
        end
    elseif mode == "dict" then
        for k, v in pairs(self) do
            if not tonumber(k) then
                if type(v) == "string" then
                    str = str .. k .. ' = "' .. tostring(v) .. '"' .. sep
                else
                    str = str .. k .. ' = ' .. tostring(v) .. sep
                end
            end
        end
    elseif mode == "table" then
        for k, v in pairs(self) do
            if tonumber(k) then
                str = str .. tostring(v) .. sep
            else
                str = str .. k .. ' = ' .. tostring(v) .. sep
            end
        end
    end
    str = string.sub(str, 1, #str - #sep)
    return str
end

-- creators --

-- Creates a table as an object
function ready_table.create(new_table)
    setmetatable(new_table, { __index = meta_index })
    return new_table
end

-- Creates an array as an object
-- (locks creation of named indexes)
function ready_table.create_array(new_table)
    setmetatable(new_table,
        {
            __newindex = function(t, key, value)
                if not tonumber(key) then
                    error('attempt to create a named index in array', 2)
                else
                    rawset(t, key, value)
                end
            end,
            __index = meta_index
        })
    return new_table
end

-- Creates a dictionary as an object
-- (locks creation of numbered indexes)
function ready_table.create_dict(new_table)
    setmetatable(new_table,
        {
            __newindex = function(t, key, value)
                if tonumber(key) then
                    error('attempt to create a numbered index in dict', 2)
                else
                    rawset(t, key, value)
                end
            end,
            __index = meta_index
        })
    return new_table
end

-- returns the library
return ready_table
