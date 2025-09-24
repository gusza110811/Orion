local node = require("node")
local utils = require("utils")

-- Ze root!
local game = node.Node:new()
game:config {
    name = "game"
}

-- Thingies
local scene = node.Node:new()
scene:config {
    name = "Scene2d",
    parent = game
}
local storage = node.Node:new()
storage:config {
    name = "Storage",
    parent = game
}
local scriptStorage = node.Node:new()
scriptStorage:config {
    name = "ScriptStorage",
    parent = game
}

local test = node.Node:new()
test:config {
    name = "Dummy",
    parent = scene
}
local testdupe = node.Node:new()
testdupe:config {
    name = "Dummy",
    parent = scene
}
local test2 = node.Node:new()
test2:config {
    name = "Dumb",
    parent = scene
}

print(utils.tableToString(game:getChildren()))

print(utils.getTree(game))
