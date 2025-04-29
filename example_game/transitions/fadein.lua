local DEFAULT_COLOR = { 1,1,1,1 } -- white

local FadeInTransition = {}
FadeInTransition.__index = FadeInTransition

FadeInTransition.new = function(config)
    config = config or {}

    local self = setmetatable({}, FadeInTransition)

    self.target_color = config.color or {0, 0, 0, 0}
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