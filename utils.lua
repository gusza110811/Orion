local Module = {}

-- make a list of numbers from `start` to `stop` with frequency `step`
function Module.range(start, stop, step)
    step = step or 1
    local t = {}
        for i = start, stop, step do
            table.insert(t, i)
        end
    return t
end
-- check if `value` is in `list`
function Module.contains(list, value)
    for _, item in ipairs(list) do
        if item == value then
            return true
        end
    end
    return false
end

-- create a read-only table
function Module.readOnly(t)
    local proxy = {} -- Create a new empty table to act as a proxy
    local mt = {     -- Define a metatable for the proxy
        __index = t, -- When a key is accessed on the proxy, look it up in the original table 't'
        __newindex = function(tbl, key, value)
            error("Attempt to modify a read-only table", 2) -- Raise an error if an attempt is made to set a value
        end
    }
    setmetatable(proxy, mt) -- Set the metatable for the proxy table
    return proxy
end

-- recursively creates a string representation of a table
function Module.tableToString(tbl, indent, referencedTables)
    indent = indent or 0
    referencedTables = referencedTables or {tbl=true}
    local stopKeys = {parent=true}

    local result = "{\n"
    local spacing = string.rep("  ", indent + 1)

    for k, v in pairs(tbl) do
        -- Format key
        local key
        if type(k) == "string" then
            key = string.format("%q", k)
        else
            key = string.format("%s", tostring(k))
        end

        local value
        if type(v) == "table" then
            if referencedTables[v] then
                stopKeys[k] = true
            end
            referencedTables[v] = true
            if stopKeys[k] then
                value = "<Loops back>"
            else
                -- normal recursion
                value = Module.tableToString(v, indent + 1, referencedTables)
            end
        elseif type(v) == "string" then
            value = string.format("%q", v)
        else
            value = tostring(v)
        end

        result = result .. spacing .. key .. " : " .. value .. ",\n"
    end

    result = result .. string.rep("  ", indent) .. "}"
    return result
end

-- get a tree representation of a node
function Module.getTree(root,indent)
    indent = indent or 0
    local result = string.rep("| ", indent) .. "- " .. root.name
    local children = root.Children
    local value
    local length = #children
    if length > 0 then
        result = result .. "\n"
    end
    for index, v in ipairs(children) do
        value = Module.getTree(v,indent+1)

        result = result .. value
        if index < length then
            result = result .. "\n"
        end
    end
    return result
end

-- find the index of a value in an array-like table
function Module.getIndex(table,value)
    local index = nil
    for i, v in ipairs(table) do
        if v == value then
            index = i
            break
        end
    end
    return index
end

-- Merges `merger` *into* `mergee`
---comment
---@param mergee table
---@param merger table
---@param ignore? table
function Module.mergeInplace(mergee,merger,ignore)
    ignore = ignore or {}
    for k, v in pairs(merger) do
        mergee[k] = v
    end
end

-- create a shallow copy of a table
function Module.shallowCopy(table)
    local shallow_copy = {}
    for k, v in pairs(table) do
        shallow_copy[k] = v
    end
    return shallow_copy
end

---@generic T
---@param class T
---@return T
local function inherit(self, class)
    class.__index = class

    -- Add constructor if none exists
    if not class.new then
        function class:new()
            return setmetatable({}, self)
        end
    end

    -- Inherit from this class
    class.inherit = inherit

    return class
end

-- Shorthand for creating class
---@generic T
---@param class T
---@return T
function class(class)
    return inherit({},class)
end

return Module