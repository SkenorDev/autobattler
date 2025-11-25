ShopClass = {}
ShopClass.__index = ShopClass 

function ShopClass:new(slotNumber,piece,name,windowWidth, windowHeight)
    local shop = setmetatable({}, ShopClass)
    shop.width = windowWidth * 0.20       -- 20% of window width
    shop.height = 120 
    shop.piece = piece
    shop.slot =slotNumber
    shop.name =name
    shop.x = (slotNumber - 1) * shop.width  -- position based on slot number (0-indexed internally)
    shop.y = windowHeight - shop.height  -- bottom aligned
    return shop
end

function ShopClass:draw()
    love.graphics.setColor(0.2, 0.2, 0.2, 1) -- dark gray background
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1,1,1,1) -- reset color to white
    
    -- Optional: draw slot number
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(self.name, self.x + 10, self.y + 40)
end

function ShopClass:update(dt)
    -- update logic if needed
end
