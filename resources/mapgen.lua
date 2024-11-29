local mapgen = {}
function mapgen:genMap(width, height)
    print('generating...')
    
    mapgen.tilemap = {}
    mapgen.tilemap.width = width --21
    mapgen.tilemap.height = height --14
    mapgen.tilemap.tileWidth = 32
    mapgen.tilemap.tileHeight =32
    mapgen.tilemap.map = {}
    mapgen.tilemap.wallOdds = math.random(7, 15)
    
    for i = 1, mapgen.tilemap.height do
        if i==1 then
            mapgen.tilemap.map[i] = {1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3}
        elseif i==mapgen.tilemap.height then
            mapgen.tilemap.map[i] = {8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8}
        else
            mapgen.tilemap.map[i] = {}
        end
        for j = 1, mapgen.tilemap.width do
            if j==1 then
            mapgen.tilemap.map[i][j] = 4
            elseif j==mapgen.tilemap.width then
                mapgen.tilemap.map[i][j] = 6
            elseif i==1 then
            elseif i>=2 and i<=13 then
                --mapgen.tilemap.wallOdds = math.random(1, 10)
                if math.random(mapgen.tilemap.wallOdds) == math.random(1) then
                    mapgen.tilemap.map[i][j] = 10
                else
                    mapgen.tilemap.map[i][j] = 5
                end
                        
                --tilemap.map[i][j] = 5 --middle, modifiable part of map
            elseif i == mapgen.tilemap.height then
            else
                mapgen.tilemap.map[i][j] = j
            end
        end
    end

    return mapgen.tilemap.map
end
--[[
print 'generated map. printing:'
--print map. debug only
for i = 1, mapgen.tilemap.height do
    for j = 1, mapgen.tilemap.width do
        io.write(mapgen.tilemap.map[i][j])
    end
end
]]

return mapgen