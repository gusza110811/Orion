local Module = {}
local utils = require("utils")

---@type Node
Module.Node = class {
    new = function (self)
        local obj = {}
        setmetatable(obj,self)
        obj.Children = {}
        self.parent = nil
        self.name = "Node"
        self.class = "Node"
        return obj
    end,
    --[[Child proxy shorthand  
    `Node.c.child.grandchild` is equivalent to `Node:getChildren("child"):getChildren("grandchild")`
    ]]
    c = setmetatable({}, {
        __index = function(self, key)
            for _, child in ipairs(self.Children) do
                if child.name == key then
                    return child
                end
            end
            return nil -- or error("No child named " .. key)
        end
    }),
    _readOnly = {_readOnly=true,class=true},

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
        utils.mergeInplace(self,configs)
    end
}


return Module
