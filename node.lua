local Module = {}
local utils = require("utils")

Module.Node = {}
Module.Node.__index = Module.Node

local nodeCounter = 0 -- for auto-naming

function Module.Node.new(name,parent)
    local self = setmetatable({}, Module.Node)
    self.locked = false

    nodeCounter = nodeCounter + 1
    self.Name = name or ("Node" .. tostring(nodeCounter))

    self.Parent = parent
    self.Children = {}

    return self
end

function Module.Node:lock()
    self.locked = true
end

-- custom getter
function Module.Node:__index(key)
    if key == "Name" then
        return rawget(self, "Name")
    elseif key == "Parent" then
        return rawget(self, "Parent")
    end
    print(self.Children)
    if utils.contains(self.Children,key) then
        return rawget(self.Children, key) -- methods
    else
        return rawget(self, key)
    end
end

-- custom setter
function Module.Node:__newindex(key, value)

    if key == "Name" then
        if self.locked then
            error("Cannot rename a locked Node")
        end
        local oldName = rawget(self, "Name")
        rawset(self, "Name", value)

        -- if parent exists, update dictionary
        local parent = rawget(self, "Parent")
        if parent then
            parent.Children[value] = self
            if oldName then
                parent.Children[oldName] = nil
            end
        end

    elseif key == "Parent" then
        if self.locked then
            error("Cannot reparent Node")
        end
        local oldParent = rawget(self, "Parent")
        if oldParent then
            oldParent.Children[self.Name] = nil
        end

        rawset(self, "Parent", value)

        if value then
            value.Children[self.Name] = self
        end

    else
        rawset(self, key, value)
    end
end


return Module
