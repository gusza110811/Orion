local Module = {}
local utils = require("utils")

Module.Node = {}
Module.Node.__index = Module.Node

local nodeCounter = 0 -- for auto-naming

-- Create new instance of `Node`
function Module.Node.new(name,parent)
    local self = setmetatable({}, Module.Node)

    self.Children = {}
    self.parent = parent

    self._readOnly = {}
    self.class = "Node"

    nodeCounter = nodeCounter + 1
    self.name = name or ("Node" .. tostring(nodeCounter))


    rawset(self._readOnly,"_readOnly",true)
    rawset(self._readOnly,"class",true)

    self.__index = self.index

    return self
end

-- Permanently lock this instance
function Module.Node:lock()
    rawset(self._readOnly,"name",true)
    rawset(self._readOnly,"parent",true)
end

-- Get first child of matching `name`
function Module.Node:getFirstChild(name)
    for index, value in ipairs(self.Children) do
        if value.name == name then
            return value
        end
    end
    return nil
end

-- Get all children
function Module.Node:getChildren()
    return self.Children
end

-- custom getter
function Module.Node:__index(key)
    if key == "name" then
        return rawget(self, "name")
    elseif key == "parent" then
        return rawget(self, "parent")
    end
    local owned = rawget(self, key)
    local inClass = rawget(Module.Node, key)
    if owned then
        return owned
    elseif inClass then
        return inClass
    end
end

-- custom setter
function Module.Node:__newindex(key, value)
    if self._readOnly then
        if self._readOnly[key] then error("Attempted to modify a read-only attribute") end
    end

    if key == "name" then
        rawset(self, "name", value)

    elseif key == "parent" then
        local oldParent = rawget(self, "parent")
        if oldParent then
            oldParent.Children[utils.getIndex(oldParent.Children,self)] = nil
        end

        rawset(self, "parent", value)

        if value then
            table.insert(value.Children,self)
        end

    else
        rawset(self, key, value)
    end
end

return Module
