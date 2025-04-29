local Scn = require("scn")
local MainMenuScene = require("example_game.scenes.MainMenu")
local GameplayScene = require("example_game.scenes.Gameplay")

love.load = function()
    Scn.register(MainMenuScene) -- default scene
    Scn.register(GameplayScene)
end

love.draw = function()
    Scn.draw()
end

love.update = function(dt)
    Scn.update(dt)
end