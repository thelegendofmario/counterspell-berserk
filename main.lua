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
    quad:set_image("resources/sprites/tiles.png", 4, 3)
    quad:make_quads()
    Tilemap = {
        {01,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,03},
        {05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,07},
        {05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,07},
        {05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,07},
        {05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,07},
        {05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,07},
        {05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,07},
        {09,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11},
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
        sword = {dir = "left",x = player.tile_x, speed=1, y= player.tile_y}
        
        table.insert(swords, sword)
        for i, val in ipairs(swords) do
            print(val)
        end
    end
end

function love.update(dt)
    berserkBar.width = berserkBar.width - berserkBar.decayRate
    for i, sword in ipairs(swords) do
        if sword.dir == 'left' then
            sword.x = sword.x - sword.speed
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
    for i,j in ipairs(swords) do
        love.graphics.draw(love.graphics.newImage("resources/sprites/player.png"), j.x, j.y)
    end
    love.graphics.draw(player.image, player.tile_x*quad.twidth-quad.twidth, player.tile_y*quad.theight-quad.theight)
    berserkBar:draw()
end