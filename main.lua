---@diagnostic disable: undefined-global, lowercase-global, redundant-parameter
local moonshine = require "resources.libraries.moonshine-master"
require "resources.libraries.TEsound"

local spawnOdds = 15
function isBadEnemySpawn(x, y)
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
    local enemy = {}
    repeat
        enemy.image = love.graphics.newImage('resources/sprites/enemy.png')
        enemy.speed = 1
        enemy.damage = 1
        enemy.rebound_chance = math.min(math.max(0.15, math.random()), 0.3)
        -- enemy = require 'resources.enemy'
        enemy.tile_x = math.random(1, #Tilemap[1])
        enemy.tile_y = math.random(1, #Tilemap)
    until tilemap[enemy.tile_y][enemy.tile_x] == 5 and not isBadEnemySpawn(enemy.tile_x, enemy.tile_y)
    return enemy
end

function init_vars()
    TEsound.play("resources/sfx/counterspell.mp3", "stream", "music", 0.1)
    game = {
        killed = 0,
        state = "menu",
        totalSpawnedEnemy = 0,
        deathMessage = "",
        gameOverCoolDown = 4
    }
    swords = {}
    player.hearts = 5
    player.swords = 5
    repeat
        player.tile_x = math.floor(math.random(2, #Tilemap[1] - 1))
        player.tile_y = math.floor(math.random(2, #Tilemap - 1))
    until Tilemap[player.tile_y][player.tile_x] == 5

    berserkBar = {
        count = 3,
        decayRate = 0.004
    }

    function berserkBar:draw()
        for i = 1, math.ceil(berserkBar.count) do
            love.graphics.draw(love.graphics.newImage("resources/sprites/berserk-star.png"), 49 + i * 12,
                screen_height - 39)
        end
    end
    function player:drawBar()
        for i = 1, self.swords do
            love.graphics.draw(love.graphics.newImage("resources/sprites/sword.png"), screen_width - i * 62,
                screen_height - 64)
        end
    end
    enemies = {}
    enemy = spawnEnemy(Tilemap)
    table.insert(enemies, enemy)
end

function love.load()
    love.graphics.setNewFont(60)

    quad = require 'resources.quadify'
    quad:set_image("resources/sprites/tiles.png", 3, 5)
    quad:make_quads()
    Tilemap = {{1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6},
               {11, 12, 12, 13, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 10, 10, 10, 10, 10}}
    screen_height = (quad.twidth * #Tilemap)
    screen_width = (quad.theight * #Tilemap[1])
    love.window.setMode(screen_width, screen_height)
    effect = moonshine(screen_width, screen_height, moonshine.effects.glow).chain(moonshine.effects.crt).chain(
                 moonshine.effects.vignette).chain(moonshine.effects.scanlines)

    effect.glow.min_luma = 0.9
    effect.glow.strength = 3

    effect.vignette.radius = 1.2
    effect.vignette.softness = 0.9

    effect.crt.distortionFactor = {1.06, 1.065}
    effect.scanlines.width = 1

    player = require 'resources.player'

    init_vars()
end

function love.keypressed(k)
    local switch = {
        ["menu"] = function()
            game.state = "playing"
        end,
        ["playing"] = function()
            player:update(k)
            if player.swords > 0 then
                local directions = {
                    left = {
                        x = -1,
                        y = 0
                    },
                    right = {
                        x = 1,
                        y = 0
                    },
                    up = {
                        x = 0,
                        y = -1
                    },
                    down = {
                        x = 0,
                        y = 1
                    }
                }

                local dir = directions[k]
                if dir then
                    local speedAdjustment = math.random(-1, 1) * 0.15
                    local sword = {
                        dir = k,
                        x = (player.tile_x - 1 + dir.x) * quad.twidth,
                        y = (player.tile_y - 1 + dir.y) * quad.theight,
                        speedAdjustment = speedAdjustment,
                        speed = {
                            x = dir.x * 4 + dir.x * 4 * speedAdjustment,
                            y = dir.y * 4 + dir.y * 4 * speedAdjustment
                        },
                        timeOut = 2.5,
                        frame = 1,
                        name = "sword" .. game.totalSpawnedEnemy
                    }

                    table.insert(swords, sword)
                    game.totalSpawnedEnemy = game.totalSpawnedEnemy + 1
                    player.swords = player.swords - 1
                    TEsound.play({"resources/sfx/swing-whoosh1.mp3", "resources/sfx/swing-whoosh2.mp3"}, "static",
                        "sfx", 0.3)
                    TEsound.play("resources/sfx/spin-whoosh1.mp3", "static", {sword.name, "sfx"}, 0.01)
                end
            end
        end,
        ["gameOver"] = function()
            if game.gameOverCoolDown > 0 then
                return
            end
            game.state = "menu"
            print 'restarting'
            init_vars()
        end
    }
    if k == "q" then
        love.event.quit()
    else
        switch[game.state]()
    end
end

local timer = 0
function love.update(dt)
    TEsound.cleanup()
    local switch = {
        ["menu"] = function()
        end,
        ["playing"] = function()
            player.hearts = math.min(5, player.hearts + player.heartRegenAmount)
            berserkBar.count = math.min(10, berserkBar.count - berserkBar.decayRate)
            if berserkBar.count <= 0 then
                game.state = "gameOver"
                game.deathMessage = "You ran out of berserk ^-^"
            elseif player.hearts <= 0 then
                game.state = "gameOver"
                game.deathMessage = "You ran out of hearts :("
            end

            if game.state == "gameOver" then
                if game.killed == 0 then
                    game.deathMessage = game.deathMessage .. "\nYou didn't kill any furballs..."
                else
                    game.deathMessage = game.deathMessage .. "\nYou killed " .. game.killed .. " furballs..."
                end
                return
            end

            for _, enemy in ipairs(enemies) do
                if player.tile_x == enemy.tile_x and player.tile_y == enemy.tile_y then
                    player.hearts = player.hearts - enemy.damage
                end
            end
            for i, sword in ipairs(swords) do
                local speedMultiplier = 1 + 1 * sword.speedAdjustment + (2.5 - sword.timeOut) * 0.4
                sword.x = sword.x + sword.speed.x * speedMultiplier
                sword.y = sword.y + sword.speed.y * speedMultiplier
                sword.frame = (sword.frame + 0.6 + speedMultiplier / 2) % 17
                sword.timeOut = sword.timeOut - dt

                if sword.timeOut <= 0 then
                    TEsound.stop(sword.name)
                    table.remove(swords, i)
                    player.swords = player.swords + 1
                elseif sword.x < -0.5 * quad.twidth and sword.dir == "left" then
                    sword.x = screen_width
                elseif sword.x > screen_width and sword.dir == "right" then
                    sword.x = -0.5
                elseif sword.y < -0.5 * quad.theight and sword.dir == "up" then
                    sword.y = screen_height
                elseif sword.y > screen_height and sword.dir == "down" then
                    sword.y = -0.5
                else
                    -- check for hitting the player
                    if sword.x >= player.tile_x * quad.twidth - quad.twidth - 3 and sword.x <= player.tile_x *
                        quad.twidth + 3 and sword.y >= player.tile_y * quad.theight - quad.theight - 3 and sword.y <=
                        player.tile_y * quad.theight + 3 then
                        player.hearts = player.hearts - 1
                        sword.x = sword.x + 4
                        table.remove(swords, i)
                        player.swords = player.swords + 1
                    end

                    -- check if it is killing an enemy
                    for j, enemy in ipairs(enemies) do
                        if sword.x >= enemy.tile_x * quad.twidth - quad.twidth - 8 and sword.x <= enemy.tile_x *
                            quad.twidth + 8 and sword.y >= enemy.tile_y * quad.theight - quad.theight - 8 and sword.y <=
                            enemy.tile_y * quad.theight + 8 then
                            -- check for a rebound
                            if math.random() < enemy.rebound_chance then
                                TEsound.play({"resources/sfx/bounce1.mp3", "resources/sfx/bounce2.mp3",
                                              "resources/sfx/bounce3.mp3"}, "static", "sfx", 0.4)
                                -- change the sword's direction by 180 degrees with a random deviation
                                local angle = math.atan2(sword.speed.y, sword.speed.x)
                                local deviation = math.rad(math.random(-55, 55))
                                angle = angle + math.pi + deviation
                                sword.speed.x = 4 * math.cos(angle)
                                sword.speed.y = 4 * math.sin(angle)
                            else
                                TEsound.play({"resources/sfx/enemy-die1.mp3"}, "static", "sfx", 0.3)
                                table.remove(enemies, j)
                                game.killed = game.killed + 1
                                berserkBar.count = berserkBar.count + 1
                                table.insert(enemies, spawnEnemy(Tilemap))
                            end
                        end
                    end
                end
            end

            timer = timer + dt
            if timer >= 0.5 then
                timer = 0
                love.updateEverySecond()
            end
        end,
        ["gameOver"] = function()
            game.gameOverCoolDown = math.max(0, game.gameOverCoolDown - dt)
        end
    }

    switch[game.state]()
end

function love.updateEverySecond()
    -- Code to be executed every second
    for i, enemy in ipairs(enemies) do
        update_enemies(enemy)
    end
    if math.random(spawnOdds) == 1 then
        table.insert(enemies, spawnEnemy(Tilemap))
    end
end

function love.draw()
    love.graphics.setDefaultFilter("nearest", "nearest")
    effect(function()
        local switch = {
            ["menu"] = function()
                love.graphics.draw(love.graphics.newImage("resources/sprites/title-screen.png"), 0, 0)
            end,
            ["playing"] = function()
                quad:draw(Tilemap)
                for i, j in ipairs(swords) do
                    love.graphics.draw(love.graphics.newImage(
                        "resources/sprites/sword/sword" .. math.floor(j.frame + 1) .. ".png"), j.x, j.y)
                end
                for i, j in ipairs(enemies) do
                    love.graphics.draw(j.image, j.tile_x * quad.twidth - quad.twidth,
                        j.tile_y * quad.theight - quad.theight)
                end
                love.graphics.draw(player.image, player.tile_x * quad.twidth - quad.twidth,
                    player.tile_y * quad.theight - quad.theight)
                berserkBar:draw()
                player:drawBar()
                player:drawHearts()
            end,
            ["gameOver"] = function()
                -- print("game over")
                local message = "Game Over\n" .. game.deathMessage
                if game.gameOverCoolDown > 0 then
                    message = message .. "\n\n" .. math.ceil(game.gameOverCoolDown)
                else
                    message = message .. "\n\npress any key to play again..."
                end

                love.graphics.printf("Game Over\n" .. message, 0, screen_height / 4, screen_width, 'center')

                -- cooldown bar
                love.graphics.rectangle("fill", screen_width / 6, screen_height - 80,
                    screen_width * game.gameOverCoolDown / 3 / 1.5, 20)
            end
        }

        switch[game.state]()
    end)
end

function update_enemies(target)
    local x = target.tile_x
    local y = target.tile_y

    -- pick a random direction and then randomly decide to move in that direction
    local direction = math.random(4)
    if direction == 1 then
        y = y - target.speed
    end
    if direction == 2 then
        y = y + target.speed
    end
    if direction == 3 then
        x = x - target.speed
    end
    if direction == 4 then
        x = x + target.speed
    end

    if isEmpty(x, y) then
        target.tile_x = x
        target.tile_y = y
    end
end

function isEmpty(x, y)
    return Tilemap[y][x] == 5
end
