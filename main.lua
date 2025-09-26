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
local testdupe = test:clone()
local testscript = node.Script:new()
testscript:config {
    parent = scene,
    script = "print('meow')"
}

print(utils.tableToString(game))

print(utils.getTree(game))
