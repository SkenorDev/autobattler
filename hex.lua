require "vector"

HexClass = {}
HexClass.__index = HexClass 

local hexImage = love.graphics.newImage("Assets/Hexagon-Blank.png")
local HEX_WIDTH  = hexImage:getWidth()
local HEX_HEIGHT = hexImage:getHeight()

function HexClass:new(x, y,dx,dy)
    local hex = setmetatable({}, HexClass)

    hex.x = x
    hex.y = y
    hex.dx= dx
    hex.dy= dy
    
    -- optional scale
    hex.scaleX = 0.1
    hex.scaleY = 0.1

    return hex
end

function HexClass:draw()
  
  
  
    love.graphics.draw(
        hexImage,  -- the shared image
        self.dx,
        self.dy,
        0,             -- rotation
        self.scaleX,   -- x scale
        self.scaleY    -- y scale
    )
end

function HexClass:update(dt)
end
