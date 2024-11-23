---@diagnostic disable: undefined-global, lowercase-global
function love.load()
    --[[
    --wf = require "resources.libraries.windfield-master.windfield"
    world = love.physics.newWorld(0,0,true)
    world:setGravity(0,512)
    ]]
    p = require 'resources.player'
end

function love.update(dt)
    p:update()
end

function love.draw()
    love.graphics.scale(p.scale[1],p.scale[2])
    love.graphics.draw(p.image, p.x,p.y)
end