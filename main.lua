-- Group 32 170
require "hex"
require "hexSpawner"
require "piece"
require "pieceSpawner"
require "action"
io.stdout:setvbuf("no")

function love.load()
  love.window.setTitle("TFT RIPOFF I THINK?")
  screenWidth = 600
  screenHeight = 600
  love.window.setMode(screenWidth, screenHeight)
  
  radius = 7
  -- makes hexGrid table
  makeGrid(radius)
  
  allies={}
  enemies={}
  spawnAlly(0,0,"kenny")
  spawnEnemy(7,7,"harold")
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
    debug()
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
  end
  
function debug()
  print("--- DEBUG INFO ---")
  for i, ally in ipairs(allies) do
    if ally.target then
      print("Ally target:", ally.target.name)
    else
      print("Ally target: none")
    end
  end
  for i, enemy in ipairs(enemies) do
    if enemy.target then
      print("Enemy target:", enemy.target.name)
    else
      print("Enemy target: none")
    end
  end
end