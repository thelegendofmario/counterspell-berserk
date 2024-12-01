local player = {}
player.tile_x = 2
player.tile_y = 2
player.image = love.graphics.newImage('resources/sprites/character.png')
player.speed = 1
player.swords = 5
player.hearts = 4
player.heartRegenAmount = 0.0005
player.maxHearts = 5 -- player.hearts
function player:update(k)
    local x = self.tile_x
    local y = self.tile_y
    if k == 'w' then
        y = y - self.speed
    end
    if k == 's' then
        y = y + self.speed
    end
    if k == 'a' then
        x = x - self.speed
    end
    if k == 'd' then
        x = x + self.speed
    end

    if isEmpty(x, y) or isPotion(x, y) then
        self.tile_x = x
        self.tile_y = y
    end

    if isPotion(x, y) and player.hearts ~= player.maxHearts then
        self.hearts = self.hearts + 1
        Tilemap[self.tile_y][self.tile_x] = 5
    end
end

function player:drawHearts()
    for i = 0, math.ceil(self.hearts) do
        love.graphics.draw(love.graphics.newImage("resources/sprites/player-heart.png"), 0 + i * 62, 0)
    end
end

function isPotion(x, y)
    return Tilemap[y][x] == 11
end

function isEmpty(x, y)
    return Tilemap[y][x] == 5
end

return player
