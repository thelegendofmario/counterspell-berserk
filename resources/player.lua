local player = {}
player.tile_x = 2
player.tile_y = 2
player.image = love.graphics.newImage('resources/sprites/player.png')
player.speed = 1
--player.scale = {0.2,0.2}


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



    if isEmpty(x, y) then
        self.tile_x = x
        self.tile_y = y
    end
end
function isEmpty(x,y)
    return Tilemap[y][x] == 0
end

return player