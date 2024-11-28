local enemy = {}
enemy.tile_x = 6
enemy.tile_y = 4
enemy.image = love.graphics.newImage('resources/sprites/enemy.png')
enemy.speed = 1
enemy.rebound_chance = math.min(math.max(0.15, math.random()), 0.3)

function enemy:update(player, swords)
    local x = self.tile_x
    local y = self.tile_y

    -- pick a random direction and then randomly decide to move in that direction
    local direction = math.random(4)
    if direction == 1 then
        y = y - self.speed
    end
    if direction == 2 then
        y = y + self.speed
    end
    if direction == 3 then
        x = x - self.speed
    end
    if direction == 4 then
        x = x + self.speed
    end

    if isEmpty(x, y) then
        self.tile_x = x
        self.tile_y = y
    end
end

function isEmpty(x, y)
    return Tilemap[y][x] == 5
end

return enemy
