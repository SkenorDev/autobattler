require "vector"
require "distanceHelper"
PieceClass = {}
PieceClass.__index = PieceClass 

local pieceImage = love.graphics.newImage("Assets/Square.png")


function PieceClass:new(x, y,name,team)
    local piece = setmetatable({}, PieceClass)
     piece.x=x
     piece.y=y
     piece.scaleX = 0.025
     piece.scaleY = 0.025
     
     piece.team = team
     piece.name= name
     piece.hp = 100
     piece.target = nil
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
  if self.team == 1 then 
  self:updateTargetEnemy()
  else 
  self:updateTargetAlly()
  end
end
function PieceClass:updateTargetEnemy()
  if self.target ~= nil and self.target.hp <= 0 then
    self.target = nil
  end
  
  local closestDistance = math.huge  
  local closestAlly = nil
  local selfAxial = offsetToAxial(self.x, self.y)
  
  for _, ally in ipairs(allies) do
    local allyAxial = offsetToAxial(ally.x, ally.y)
    local temp = hexDistance(selfAxial, allyAxial)
    
    if temp < closestDistance then
      closestDistance = temp
      closestAlly = ally
    end
  end

  self.target = closestAlly
end

function PieceClass:updateTargetAlly()
  if self.target ~= nil and self.target.hp <= 0 then
    self.target = nil
  end
  
  local closestDistance = math.huge  
  local closestEnemy = nil
  local selfAxial = offsetToAxial(self.x, self.y)
  
  for _, enemy in ipairs(enemies) do
    local enemyAxial = offsetToAxial(enemy.x, enemy.y)
    local temp = hexDistance(selfAxial, enemyAxial)
    
    if temp < closestDistance then
      closestDistance = temp
      closestEnemy = enemy
    end
  end 

  self.target = closestEnemy
end


  