---@class Scn
---@field scenes table
---@field current table|nil
---@field mid_transition boolean
---@field private _prev table|nil
---@field private _next table|nil
---@field private _transition table|nil
local Scn = {
    _VERSION     = 'scn 0.1.1',
    _DESCRIPTION = 'scn is a minimal abstraction built on top of love2d to manage scenes and transitions.',
    _URL         = 'https://github.com/wiredsoft-xyz/scn',
    _LICENSE     = [[
        MIT LICENSE

        Copyright (c) 2025 WiredSoft SAS

        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]],
    scenes = {},
    current = nil,
    _prev = nil,
    _next = nil,
    _transition = nil,
    mid_transition = false
}
Scn.__index = Scn

Scn._validate = function(scene)
    assert(type(scene) == 'table')
    assert(type(scene.name) == 'string')
    assert(type(scene.enter) == 'function')
    assert(type(scene.draw) == 'function')
    assert(type(scene.update) == 'function')
    assert(type(scene.exit) == 'function')
end

Scn.register = function(scene)
    Scn._validate(scene) -- trigger validations
    Scn.scenes[scene.name] = scene
    if Scn.current == nil then
        Scn.current = scene -- set as default scene if none set yet
        Scn.current:enter()
    end
end

Scn.switch = function (name, transition)
    assert(type(name) == 'string')
    assert(type(transition) == 'nil' or type(transition) == 'table')
    if Scn.mid_transition then return end

    local prev = Scn.current -- temporarily store previous scene
    Scn._next = Scn.scenes[name]

    local is_same_scene = Scn.current == Scn._next -- edge case: scene reload / play transition in `enter`

    if not transition then
        if not is_same_scene then
            Scn.current = Scn._next -- replace active scene
            Scn.current:enter()
            if prev then prev:exit() end
        end
    else
        assert(type(transition) == 'table')
        Scn._prev = prev
        Scn._transition = transition
        Scn.mid_transition = true
    end
end

Scn.update = function(dt)
    Scn.current:update(dt)

    if Scn._transition ~= nil then
        if Scn._transition.completed then
            Scn._transition = nil
            Scn.mid_transition = false

            local is_same_scene = Scn.current == Scn._next

            if not is_same_scene then
                Scn.current = Scn._next
                Scn._next = nil
                Scn.current:enter()

                if Scn._prev then Scn._prev:exit() end
                Scn._prev = nil
            end
        else
            Scn._transition:update(dt)
        end
    end
end

Scn.draw = function()
    Scn.current:draw()

    if Scn._transition ~= nil then Scn._transition:draw() end
end

return Scn