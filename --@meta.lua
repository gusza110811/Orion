---@meta

---@class Class
---@field new function Create an instance of this class
---@field inherit function Create an inherited class from this base
local Class = {}

---@class Node:Class
---@field new fun(self):Node Create a new Node
---@field clone fun(self):self Create a clone of this Node
---@field parent Node|nil The node's parent
---@field name string The node's name
---@field class string The node's class
---@field c table For quickly accessing to child objects. `node.c.child.grandchild` is equivalent to `node:getChildren("child"):getChildren("grandchild")`
---@field inherit fun(self, class):table For inheriting from this node
---@field lock fun(self):nil Lock this node permanently
---@field getFirstChild fun(self, name):Node Get first child of matching `name`
---@field getChildren fun(self):table,Node Get all children
---@field config fun(self, configs) Quickly configure the node
---@field __index Node
---@field __newindex function
local Node = {}

---@class Script:Node
---@field new fun(self):Script Create a new script
---@field source string Source file
---@field script string Loaded script
---@field super Node
local Script = {}