---@diagnostic disable: undefined-global, lowercase-global



function love.load()
    --[[
    --wf = require "resources.libraries.windfield-master.windfield"
    world = love.physics.newWorld(0,0,true)
    world:setGravity(0,512)
    ]]
    swords = {}
    player = require 'resources.player'
    quad = require 'resources.quadify'
    quad:set_image("resources/sprites/tiles.png", 3, 3)
    quad:make_quads()
    Tilemap = {
        {1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9},
    }
    screen_height = (quad.twidth*#Tilemap)
    screen_width = (quad.theight*#Tilemap[1])
    love.window.setMode(screen_width, screen_height)
    berserkBar = {
        width = 64,
        height = 32,
        decayRate = 0.001
    }
    berserkBar.x = 0
    berserkBar.y = screen_height-berserkBar.height

    function berserkBar:draw()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
    
end





function love.keypressed(k)
    player:update(k)
    if k == "left" then
        sword = {dir = "left", x = (player.tile_x-2)*quad.twidth, speed = {x = -1, y = 0}, y = (player.tile_y-1)*quad.theight, frame = 1}
    elseif k == "right" then
        sword = {dir = "right", x = player.tile_x*quad.twidth, speed = {x = 1, y = 0}, y = (player.tile_y-1)*quad.theight, frame =1}
    elseif k == "up" then
        sword = {dir = "up", x = (player.tile_x-1)*quad.twidth, speed = {x = 0, y = -1}, y = (player.tile_y-2)*quad.theight, frame =1}
    elseif k == "down" then
        sword = {dir = "down", x = (player.tile_x-1)*quad.twidth, speed = {x = 0, y = 1}, y = player.tile_y*quad.theight, frame =1}
    end
    
    if sword then
        table.insert(swords, sword)
        for i, val in ipairs(swords) do
            print(val.frame)
        end
    end
end

function love.update(dt)
    berserkBar.width = berserkBar.width - berserkBar.decayRate
    for i, sword in ipairs(swords) do
        sword.x = sword.x + sword.speed.x
        sword.y = sword.y + sword.speed.y
        sword.frame = (sword.frame + 0.01) % 17 + 1
        if sword.x < -0.5*quad.twidth or sword.x > screen_width or sword.y < -0.5*quad.theight or sword.y > screen_height then
            table.remove(swords, i)
        end
    end
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
    --love.graphics.rectangle("fill")
    for i, j in ipairs(swords) do
        love.graphics.draw(love.graphics.newImage("resources/sprites/sword/sword"..math.floor(j.frame)..".png"), j.x, j.y)
    end
    love.graphics.draw(player.image, player.tile_x*quad.twidth-quad.twidth, player.tile_y*quad.theight-quad.theight)
    berserkBar:draw()
end