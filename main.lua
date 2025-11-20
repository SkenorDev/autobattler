-- Group 32 170
require "hex"
require "hexSpawner"
require "piece"
require "pieceSpawner"
io.stdout:setvbuf("no")

function love.load()
  love.window.setTitle("TFT RIPOFF I THINK?")
  screenWidth = 600
  screenHeight = 600
  love.window.setMode(screenWidth, screenHeight)
  
  radius = 7
  -- makes hexGrid table
  makeGrid(radius)
  
  piece=spawnPiece(1,1)
end

function love.update()
  
end

function love.draw()
  love.graphics.clear(1, 1, 1)
  for x, column in pairs(hexGrid) do
        for y, hex in pairs(column) do
            hex:draw()
        end
    end
  piece:draw()
  end
  
