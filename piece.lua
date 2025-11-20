require "vector"

PieceClass = {}
PieceClass.__index = PieceClass 

local pieceImage = love.graphics.newImage("Assets/Square.png")


function PieceClass:new(x, y)
    local piece = setmetatable({}, PieceClass)
     piece.x=x
     piece.y=y
     piece.scaleX = 0.025
     piece.scaleY = 0.025
    return piece
end

function PieceClass:draw()
  local hexagonPos=hexGrid[self.x][self.y]
  local drawx=hexagonPos.dx +23
  local drawy=hexagonPos.dy +15
    love.graphics.draw(
        pieceImage,  
        drawx,
        drawy,
        0,             -- rotation
        self.scaleX,   -- x scale
        self.scaleY    -- y scale
    )
end

function PieceClass:update(dt)
end
