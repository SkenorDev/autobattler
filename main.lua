-- Group 32 170
require "hex"
require "hexSpawner"
io.stdout:setvbuf("no")

function love.load()
  love.window.setTitle("TFT RIPOFF I THINK?")
  screenWidth = 600
  screenHeight = 600
  love.window.setMode(screenWidth, screenHeight)
  radius = 7
  -- makes hexGrid table
  makeGrid(radius)
end

function love.update()
  
end

function love.draw()
  love.graphics.clear(1, 1, 1)
  for i = 1, #hexGrid do
    hexGrid[i]:draw()
    end
  end
  
