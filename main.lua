---@diagnostic disable: undefined-global, lowercase-global
function love.load()
    --[[
    --wf = require "resources.libraries.windfield-master.windfield"
    world = love.physics.newWorld(0,0,true)
    world:setGravity(0,512)
    ]]
    player = require 'resources.player'
    quad = require 'resources.quadify'
    quad:set_image("resources/sprites/tileset.png", 3, 3)
    quad:make_quads()
    Tilemap = {
        {0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0},
    }
end

function love.keypressed(k)
    player:update(k)
end

function love.draw()
    --[[for i,row in ipairs(Tilemap) do
        for j,tile in ipairs(row) do
            if tile ~= 0 then
                --love.graphics.setColor(Colors[tile])
                love.graphics.draw(quad.base_image, quad.quads[tile], j*quad.twidth-quad.twidth,i*quad.theight-quad.theight)
            end
        end
    end]]
    quad:draw(Tilemap)
    love.graphics.draw(player.image, player.tile_x*quad.twidth-quad.twidth, player.tile_y*quad.theight-quad.theight)
end