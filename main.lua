local node = require("node")
local utils = require("utils")

-- Ze root!
local game = node.Node.new("game")

-- Thingies
local scene = node.Node.new("Scene2d",game)
local storage = node.Node.new("Storage",game)
local scriptStorage = node.Node.new("ScriptStorage",game)

print(utils.tableToString(game,0))