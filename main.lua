local node = require("node")
local utils = require("utils")

-- Ze root!
local game = node.Node.new("game")


-- Thingies
local scene = node.Node.new("Scene2d",game)
local storage = node.Node.new("Storage",game)
local scriptStorage = node.Node.new("ScriptStorage",game)

local test = node.Node.new("DummyNode",scene)
local testdupe = node.Node.new("DummyNode",scene)
local test2 = node.Node.new("DumNode",scene)

print(utils.getTree(game))

print(utils.tableToString(game:getFirstChild("Scene2d"):getChildren()))