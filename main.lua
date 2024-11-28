---@diagnostic disable: undefined-global, lowercase-global, redundant-parameter
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
    dbg_enemy_number = 3
    game = {
        killed = 0,
        state = "menu"
    }
    love.graphics.setNewFont(60)
    swords = {}
    player = require 'resources.player'
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
               {11, 12, 12, 13, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 10, 10, 10, 10}}
    screen_height = (quad.twidth * #Tilemap)
    screen_width = (quad.theight * #Tilemap[1])
    love.window.setMode(screen_width, screen_height)
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
    table.insert(enemies, spawnEnemy(Tilemap --[[, player, swords]] ))
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
                    local sword = {
                        dir = k,
                        x = (player.tile_x - 1 + dir.x) * quad.twidth,
                        y = (player.tile_y - 1 + dir.y) * quad.theight,
                        speed = {
                            x = dir.x * 4,
                            y = dir.y * 4
                        },
                        frame = 1
                    }
                    table.insert(swords, sword)
                    player.swords = player.swords - 1
                end
            end
        end,
        ["gameOver"] = function()
        end
    }

    switch[game.state]()
end

local timer = 0
function love.update(dt)
    local switch = {
        ["menu"] = function()
        end,
        ["playing"] = function()
            berserkBar.count = math.min(10, berserkBar.count - berserkBar.decayRate)
            if berserkBar.count <= 0 then
                game.state = "gameOver"
            end

            for i, sword in ipairs(swords) do
                sword.x = sword.x + sword.speed.x
                sword.y = sword.y + sword.speed.y
                sword.frame = (sword.frame + 0.4) % 17
                --[[if sword.x < -0.5 * quad.twidth or sword.x > screen_width or sword.y < -0.5 * quad.theight or sword.y >
                    screen_height then
                    table.remove(swords, i)
                    player.swords = player.swords + 1]]
                if sword.x < -0.5 * quad.twidth and sword.dir == "left" then
                    sword.x = screen_width
                elseif sword.x > screen_width and sword.dir == "right" then
                    sword.x = -0.5
                elseif sword.y < -0.5 * quad.theight and sword.dir == "up" then
                    sword.y = screen_height
                elseif sword.y > screen_height and sword.dir == "down" then
                    sword.y = -0.5
                else
                    -- check if it is killing an enemy
                    for j, enemy in ipairs(enemies) do
                        if sword.x >= enemy.tile_x * quad.twidth - quad.twidth - 8 and sword.x <= enemy.tile_x *
                            quad.twidth + 8 and sword.y >= enemy.tile_y * quad.theight - quad.theight - 8 and sword.y <=
                            enemy.tile_y * quad.theight + 8 then
                            table.insert(enemies, spawnEnemy(Tilemap, player, swords))
                            table.remove(enemies, j)
                            table.remove(swords, i)
                            game.killed = game.killed + 1
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
        end,
        ["gameOver"] = function()
        end
    }

    switch[game.state]()
end

function love.updateEverySecond()
    -- Code to be executed every second
    for i, enemy in ipairs(enemies) do
        enemy:update(player, swords)
    end
end

function love.draw()
    local switch = {
        ["menu"] = function()
            love.graphics.draw(love.graphics.newImage("resources/sprites/title-screen.png"), 0, 0)
        end,
        ["playing"] = function()
            quad:draw(Tilemap)
            for i, j in ipairs(swords) do
                love.graphics.draw(love.graphics.newImage("resources/sprites/sword/sword" .. math.floor(j.frame + 1) ..
                                                              ".png"), j.x, j.y)
            end
            for i, j in ipairs(enemies) do
                love.graphics
                    .draw(j.image, j.tile_x * quad.twidth - quad.twidth, j.tile_y * quad.theight - quad.theight)
            end
            love.graphics.draw(player.image, player.tile_x * quad.twidth - quad.twidth,
                player.tile_y * quad.theight - quad.theight)
            berserkBar:draw()
            player:drawBar()
        end,
        ["gameOver"] = function()
            love.graphics.printf("Game Over :(\nYou killed " .. game.killed .. " furballs", 0, screen_height / 3,
                screen_width - 100, 'center')
        end
    }

    switch[game.state]()
end
