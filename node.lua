local Module = {}
local utils = require("utils")

---@type Node
Module.Node = class {
    new = function (self)
        local obj = {}
        setmetatable(obj,self)
        obj.Children = {}
        obj.parent = nil
        obj.name = "Node"
        obj.class = "Node"
        obj._readOnly = {_readOnly=true,class=true}
        --[[Child proxy shorthand  
        `Node.c.child.grandchild` is equivalent to `Node:getChildren("child"):getChildren("grandchild")`
        ]]
        obj.c = setmetatable({}, {
            __index = function(self, key)
                for _, child in ipairs(self.Children) do
                    if child.name == key then
                        return child
                    end
                end
                return nil
            end
        })
        return obj
    end,

    -- custom setter
    __newindex = function(self, key, value)
        if self._readOnly then
            if self._readOnly[key] then error("Attempted to modify a read-only attribute " .. key) end
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
    end,

    -- Permanently lock this instance
    lock = function(self)
        rawset(self._readOnly,"name",true)
        rawset(self._readOnly,"parent",true)
    end,

    -- Get first child of matching `name`
    getFirstChild = function(self,name)
        for index, value in ipairs(self.Children) do
            if value.name == name then
                return value
            end
        end
        return nil
    end,

    -- Get all children
    getChildren = function(self)
        return utils.shallowCopy(self.Children)
    end,

    -- Quickly configure the node
    config = function (self, configs)
        return utils.mergeInplace(self,configs)
    end,

    clone = function (self)
        local obj = Module[self.class]:new()
        obj:config(self)
        if self.Children then
            for index, value in ipairs(self.Children) do
                value:clone()
                value.parent = obj
            end
        end

        return obj
    end
}

---@type Script
Module.Script = Module.Node:inherit {}
function Module.Script:new()
    local obj = self.super:new()
    obj.class = "Script"
    obj.name = "Script"
    obj.source = ""
    obj.script = ""
    return obj
end

function Module.Script:__newindex(key,value)
    if key == "script" then
        rawset(self,"script",value)
        rawset(self,"source",nil)
    elseif key == "source" then
        rawset(self,"source",value)
        local script = io.open(value,"r"):read("a")
        rawset(self,"script",script)

    else
        return self.super:__newindex(key,value)
    end
end

return Module
