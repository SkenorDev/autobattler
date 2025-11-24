-- Group 32 170
require "hex"
require "hexSpawner"
require "piece"
require "pieceSpawner"
require "action"
require "shop"
require "shopSpawner"
require "mouse"
io.stdout:setvbuf("no")

function love.load()
  love.window.setTitle("TFT RIPOFF I THINK?")
  screenWidth = 600
  screenHeight = 600
  love.window.setMode(screenWidth, screenHeight)
  
  radius = 7
  yGridStart = 55
  yGridEnd = 470
  xGridStart=60
  xGridEnd=560
  -- makes hexGrid table
  makeGrid(radius)
  shops={}
  allies={}
  enemies={}
  spawnAlly(1,0,1)
  spawnAlly(0,0,2)
  spawnEnemy(7,7,1)
  createShop(1)
end
local timeAccumulator = 0
function love.update(dt)
  timeAccumulator = timeAccumulator + dt

  if timeAccumulator >= 2 then
    -- Run your once-per-second logic:
    for i, ally in ipairs(allies) do
      ally:update()
    end
    for i, enemy in ipairs(enemies) do
      enemy:update()
    end
    for i, ally in ipairs(allies) do
      action(ally)
    end
    for i, enemy in ipairs(enemies) do
      action(enemy)
    end
    timeAccumulator = timeAccumulator - 1
  end
end

function love.draw()
  love.graphics.clear(1, 1, 1)

  local mouseX, mouseY = love.mouse.getPosition()
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Mouse: " .. mouseX .. ", " .. mouseY, 10, 10)

  love.graphics.setColor(1, 1, 1)
  for x, column in pairs(hexGrid) do
    for y, hex in pairs(column) do
      hex:draw()
    end
  end
  for _, ally in ipairs(allies) do
    ally:draw()
  end
  for _, enemy in ipairs(enemies) do
    enemy:draw()
  end
  for _, shop in ipairs(shops) do
    shop:draw()
  end
end
