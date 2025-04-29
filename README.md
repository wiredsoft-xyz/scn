# scn

scn is a minimal abstraction built on top of love2d to manage scenes and transitions.

## quickstart

simply copy the file `scn.lua` into your project, and consume it following the `code along` section below. you may also use this repository as-is as a template for a brand new love2d project.

## code along

### main.lua

```lua
-- main.lua contents:
local Scn = require("scn")

local MainMenuScene = require("scenes.MainMenu")
local GameplayScene = require("scenes.Gameplay")

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
```

### scenes/MainMenu.lua

```lua
-- scenes/MainMenu.lua contents:

local Scn = require("scn")
local FadeOutTransition = require("transitions.fadeout")

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
```

### scenes/Gameplay.lua

```lua
-- scenes/Gameplay.lua contents:
local Scn = require("scn")
local FadeInTransition = require("transitions.fadein")

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
```

### transitions/fadein.lua

```lua
-- transitions/fadein.lua contents:
local DEFAULT_COLOR = { 1,1,1,1 } -- white

local FadeInTransition = {}
FadeInTransition.__index = FadeInTransition

FadeInTransition.new = function(config)
    config = config or {}

    local self = setmetatable({}, FadeInTransition)

    self.target_color = config.color or {0, 0, 0, 0} -- transparent
    self.current_color = { self.target_color[1], self.target_color[2], self.target_color[3], 1 }
    self.speed = (config.speed or 5) / 10
    self.x = config.x or 0
    self.y = config.y or 0
    self.w = config.w or love.graphics.getWidth()
    self.h = config.h or love.graphics.getHeight()

    self.current_progress = 0 -- to 1
    self.completed = false

    return self
end

FadeInTransition.track_progress = function(self)
    self.current_progress = self.current_color[4] + 1
    self.completed = self.current_progress == 1
end

FadeInTransition.update = function(self, dt)
    self.current_color[4] = math.max(self.current_color[4] - self.speed * dt, 0)
    self:track_progress()
end

FadeInTransition.draw = function(self)
    love.graphics.setColor(self.current_color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(DEFAULT_COLOR)
end

return FadeInTransition
```

### transitions/fadeout.lua

```lua
-- transitions/fadeout.lua contents:
local DEFAULT_COLOR = { 1,1,1,1 } -- white

local FadeOutTransition = {}
FadeOutTransition.__index = FadeOutTransition

FadeOutTransition.new = function(config)
    config = config or {}

    local self = setmetatable({}, FadeOutTransition)

    self.target_color = config.color or {0, 0, 0, 1} -- black
    self.current_color = { self.target_color[1], self.target_color[2], self.target_color[3], 0 }
    self.speed = (config.speed or 5) / 10
    self.x = config.x or 0
    self.y = config.y or 0
    self.w = config.w or love.graphics.getWidth()
    self.h = config.h or love.graphics.getHeight()

    self.current_progress = 0 -- to 1
    self.completed = false

    return self
end

FadeOutTransition.track_progress = function(self)
    self.current_progress = self.current_color[4] / 1
    self.completed = self.current_progress == 1
end

FadeOutTransition.update = function(self, dt)
    self.current_color[4] = math.min(self.current_color[4] + self.speed * dt, 1)
    self:track_progress()
end

FadeOutTransition.draw = function(self)
    love.graphics.setColor(self.current_color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(DEFAULT_COLOR)
end

return FadeOutTransition
```

the transition will be triggered in the MainMenu scene when you press the space key.

## LICENSE

scn is licensed under the [MIT LICENSE](./LICENSE.md)