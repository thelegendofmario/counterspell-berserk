local player = {}
player.tile_x = 2
player.tile_y = 2
player.image = love.graphics.newImage('resources/sprites/character.png')
player.speed = 2
player.scale = {0.2,0.2}


function player:update()
    
    
    if love.keyboard.isDown('w') then
        player.y = player.y - player.speed
    end
    if love.keyboard.isDown('s') then
        player.y = player.y + player.speed
    end
    if love.keyboard.isDown('a') then
        player.x = player.x - player.speed
    end
    if love.keyboard.isDown('d') then
        player.x = player.x + player.speed
    end

    
end


return player