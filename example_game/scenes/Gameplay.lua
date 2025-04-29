local Scn = require("scn")
local FadeInTransition = require("example_game.transitions.fadein")

local GameplayScene = { name = "Gameplay" }
GameplayScene.__index = GameplayScene

GameplayScene.enter = function(self)
    love.graphics.setBackgroundColor(love.math.colorFromBytes( 100, 149, 237, 255 ))
    Scn.switch("Gameplay", FadeInTransition.new())
end

GameplayScene.draw = function(self)
    love.graphics.print("Gameplay", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

GameplayScene.update = function(self, dt)
end

GameplayScene.exit = function(self)
end

return GameplayScene