require "vector"
require "distanceHelper"
PieceClass = {}
PieceClass.__index = PieceClass 

local pieceImage = love.graphics.newImage("Assets/Square.png")
local WarriorImage = love.graphics.newImage("Assets/Warrior.png")
local ArcherImage = love.graphics.newImage("Assets/Archer.png")
local TankImage = love.graphics.newImage("Assets/Tank.png")
local pieceImages = {
    Warrior = WarriorImage,
    Archer  = ArcherImage,
    Tank    = TankImage,
}
function PieceClass:new(x, y,range,attack,hp,team,name)
    local piece = setmetatable({}, PieceClass)
     piece.x=x
     piece.y=y
     piece.scaleX = 0.025
     piece.scaleY = 0.025
     piece.range=range
      piece.attack=attack
     piece.team = team
     piece.name = name
     piece.maxhp = hp
     piece.hp = hp
     piece.target = nil
     piece.image = pieceImages[name] or pieceImage
    return piece
end

function PieceClass:draw()
  
  local hexagonPos=hexGrid[self.x][self.y]
  local drawx=hexagonPos.dx +23
  local drawy=hexagonPos.dy +15
    love.graphics.draw(
        self.image,  
        drawx,
        drawy,
        0,             -- rotation
        self.scaleX,   -- x scale
        self.scaleY    -- y scale
    )
  local barWidth = 40
  local barHeight = 6
  local barX = drawx 
  local barY = drawy - 5

  love.graphics.setColor(1, 0, 0) -- red color
  love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)

  -- Draw the health bar foreground (green) proportional to HP
  local hpPercentage = math.max(self.hp, 0) / self.maxhp -- assuming max hp 100
  love.graphics.setColor(0, 1, 0) -- green color
  love.graphics.rectangle("fill", barX, barY, barWidth * hpPercentage, barHeight)

  -- Reset color to white for other draw calls
  love.graphics.setColor(1, 1, 1)
end

function PieceClass:update(dt)
  if self.team == 1 then 
  self:updateTargetEnemy()
  else 
  self:updateTargetAlly()
  end
end
function PieceClass:updateTargetEnemy()
  if #allies == 0 then
    return 
    end
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
    if #enemies == 0 then
    return 
    end
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


  