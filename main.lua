---@diagnostic disable: undefined-global, lowercase-global


function isBadEnemySpawn(x, y)
    -- for _, enemy in ipairs(enemies) do
    --     if enemy.tile_x == x and enemy.tile_y == y then
    --         return true
    --     end
    -- end

    -- check player
    if player.tile_x == x and player.tile_y == y then
        return true
    end

    for _, sword in ipairs(swords) do
        if sword.tile_x == x and sword.tile_y == y then
            return true
        end
    end
    
    return false
end

function spawnEnemy(tilemap)
    local enemy
    repeat
        enemy = require 'resources.enemy'
        enemy.tile_x = math.random(1, #Tilemap[1])
        enemy.tile_y = math.random(1, #Tilemap)
    until tilemap[enemy.tile_y][enemy.tile_x] == 5 and not isBadEnemySpawn(enemy.tile_x, enemy.tile_y)
    return enemy
end


function love.load()
    --[[
    --wf = require "resources.libraries.windfield-master.windfield"
    world = love.physics.newWorld(0,0,true)
    world:setGravity(0,512)
    ]]
    swords = {}
    player = require 'resources.player'
    quad = require 'resources.quadify'
    quad:set_image("resources/sprites/tiles.png", 3, 5)
    quad:make_quads()
    Tilemap = {
        {1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6},
        {11,12,12,13,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,10,10,10,10,10},
    }
    screen_height = (quad.twidth*#Tilemap)
    screen_width = (quad.theight*#Tilemap[1])
    love.window.setMode(screen_width, screen_height)
    berserkBar = {
        count = 3,
        decayRate = 0.004
    }

    function berserkBar:draw()
        for i = 1, math.ceil(berserkBar.count) do
            love.graphics.draw(love.graphics.newImage("resources/sprites/berserk-star.png"), 49 + i * 12, screen_height - 39)
        end
    end
    function player:drawBar()
        for i = 1, self.swords do
            love.graphics.draw(love.graphics.newImage("resources/sprites/sword.png"), screen_width - i * 62, screen_height - 64)
        end
    end
    
    enemies = {}
    table.insert(enemies, spawnEnemy(Tilemap, player, swords))
end

function love.keypressed(k)
    player:update(k)
    speed = 4
    if player.swords ~= 0 then
        if k == "left" then
            sword = {dir = "left", x = (player.tile_x-2)*quad.twidth, speed = {x = -1*speed, y = 0}, y = (player.tile_y-1)*quad.theight, frame = 1}
        elseif k == "right" then
            sword = {dir = "right", x = player.tile_x*quad.twidth, speed = {x = 1*speed, y = 0}, y = (player.tile_y-1)*quad.theight, frame =1}
        elseif k == "up" then
            sword = {dir = "up", x = (player.tile_x-1)*quad.twidth, speed = {x = 0, y = -1*speed}, y = (player.tile_y-2)*quad.theight, frame =1}
        elseif k == "down" then
            sword = {dir = "down", x = (player.tile_x-1)*quad.twidth, speed = {x = 0, y = 1*speed}, y = player.tile_y*quad.theight, frame =1}
        end

        if sword then
            table.insert(swords, sword)
            player.swords = player.swords - 1
        end
    end
end

local timer = 0
function love.update(dt)
    berserkBar.count = berserkBar.count - berserkBar.decayRate
    for i, sword in ipairs(swords) do
        sword.x = sword.x + sword.speed.x
        sword.y = sword.y + sword.speed.y
        sword.frame = (sword.frame + 0.4) % 17
        if sword.x < -0.5*quad.twidth or sword.x > screen_width or sword.y < -0.5*quad.theight or sword.y > screen_height then
            table.remove(swords, i)
            player.swords = player.swords + 1
        else
            -- check if it is killing an enemy
            for j, enemy in ipairs(enemies) do
                if sword.x >= enemy.tile_x*quad.twidth-quad.twidth-8 and sword.x <= enemy.tile_x*quad.twidth+8 and sword.y >= enemy.tile_y*quad.theight-quad.theight-8 and sword.y <= enemy.tile_y*quad.theight+8 then
                    table.insert(enemies, spawnEnemy(Tilemap, player, swords))
                    table.remove(enemies, j)
                    table.remove(swords, i)
                    player.swords = player.swords + 1
                    berserkBar.count = berserkBar.count + 1
                end
            end
        end
    end

    timer = timer + dt
    if timer >= 0.5 then
        timer = 0
        love.updateEverySecond()
    end
end

function love.updateEverySecond()
    -- Code to be executed every second
    for i, enemy in ipairs(enemies) do
        enemy:update(player, swords)
    end
end

function love.draw()
    quad:draw(Tilemap)
    for i, j in ipairs(swords) do
        love.graphics.draw(love.graphics.newImage("resources/sprites/sword/sword"..math.floor(j.frame + 1)..".png"), j.x, j.y)
    end
    for i, j in ipairs(enemies) do
        love.graphics.draw(j.image, j.tile_x*quad.twidth-quad.twidth, j.tile_y*quad.theight-quad.theight)
    end
    love.graphics.draw(player.image, player.tile_x*quad.twidth-quad.twidth, player.tile_y*quad.theight-quad.theight)
    berserkBar:draw()
    player:drawBar()
end