local Scn = require("scn")
local FadeOutTransition = require("example_game.transitions.fadeout")

local MainMenuScene = { name = "MainMenu" }
MainMenuScene.__index = MainMenuScene

MainMenuScene.enter = function()
    love.graphics.setBackgroundColor(love.math.colorFromBytes( 36, 37, 41, 255 ))
end

MainMenuScene.draw = function()
    love.graphics.print("Main Menu", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

MainMenuScene.update = function(dt)
    if love.keyboard.isDown('space') then
        Scn.switch("Gameplay", FadeOutTransition.new())
    end

    -- you may want to prevent some of your systems from further updating while a transition is playing.
    -- if not Scn.mid_transition then -- prevent other menu buttons from being clicked for example.
        -- input_system.update() 
    -- end
end

MainMenuScene.exit = function()
end

return MainMenuScene