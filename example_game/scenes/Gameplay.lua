local Scn = require("scn")
local FadeInTransition = require("example_game.transitions.fadein")
local FadeOutTransition = require("example_game.transitions.fadeout")

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
    if love.keyboard.isDown('space') then
        Scn.switch("MainMenu", FadeOutTransition.new())
    end
end

GameplayScene.exit = function(self)
end

return GameplayScene