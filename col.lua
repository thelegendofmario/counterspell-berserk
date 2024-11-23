function check(recta, rectb)

    box1 = {}
    box1.rightx = recta.x + recta.width
    box1.leftx = recta.x
    box1.bottomy = recta.y + recta.height
    box1.topy = recta.y

    box2 = {}
    box2.rightx = rectb.x + rectb.width
    box2.leftx = rectb.x
    box2.bottomy = rectb.y + rectb.height
    box2.topy = rectb.y

    if  box2.rightx >= box1.leftx then
        if box2.leftx <= box1.rightx then
            return true 
        end

       
       -- if((box2.topy <= box1.bottomy) and (box2.bottomy >= box1.topy)) then
           -- return true;

        --else
           -- return false
       -- end

    else
        return false
    end
end

