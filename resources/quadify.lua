---@diagnostic disable: undefined-global, lowercase-global

local quad = {}
quad.quads = {}

function quad:set_image(imgPath, rows, columns)
    self.base_image = love.graphics.newImage(imgPath)
    self.image_width = self.base_image:getWidth()
    self.image_height = self.base_image:getHeight()
    self.image_rows = rows
    self.image_columns = columns
    quad.twidth = (quad.image_width / quad.image_rows) - 2
    quad.theight = (quad.image_height / quad.image_columns) - 2
end


--quad.base_image = love.graphics.newImage('assets/art/tileset/tileset.png')
--base_image = love.graphics.newImage('assets/art/tileset/tileset.png')
function quad:make_quads()
    for i=0,quad.image_columns-1 do
        for j=0,quad.image_rows-1 do
            table.insert(quad.quads,
                love.graphics.newQuad(1 + j * (quad.twidth+2), 1 + i * (quad.theight+2), quad.twidth, quad.theight, quad.image_width, quad.image_height))
        end
    end
end

function quad:draw(tilemap)
    for i,row in ipairs(tilemap) do
        for j,tile in ipairs(row) do
            if tile ~= 0 then
                --love.graphics.setColor(Colors[tile])
                love.graphics.draw(quad.base_image, quad.quads[tile], j*quad.twidth-quad.twidth,i*quad.theight-quad.theight)
            end
        end
    end
end
--print(quad.quads)
return quad
