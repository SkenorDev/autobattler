-- Group 32 170
require "hex"
require "hexSpawner"
require "piece"
require "pieceSpawner"
require "action"
require "shop"
require "shopSpawner"
require "mouse"
require "levelManager"

io.stdout:setvbuf("no")

gameState = "menu"


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
  holder=nil
  allies={}
  enemies={}
  --spawnWarrior(1,2,1)
  --spawnWarrior(6,7,0)
  createShop(1,spawnWarrior,"Warrior")
  createShop(3,spawnArcher,"Archer")
  createShop(5,spawnTank,"Tank")
  
  local level = levels[currentLevelIndex]
  loadLevel(level)

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
    for i = #allies, 1, -1 do
    local ally = allies[i]
      if ally.hp <= 0 then
        table.remove(allies, i)
        -- free the hex
        hexGrid[ally.x][ally.y].occupied = false
      end
    end
    for i = #enemies, 1, -1 do
      local enemy = enemies[i]
      if enemy.hp <= 0 then
        table.remove(enemies, i)
        -- free the hex
        hexGrid[enemy.x][enemy.y].occupied = false
      end
    end
    timeAccumulator = timeAccumulator - 1
  end
  -- WIN CONDITION:
  -- No enemies left
  if gameState == "game" and #enemies == 0 then
      gameState = "win"
      return
  end

  -- LOSE CONDITION:
  -- No allies AND usedPieces == maxPieces AND at least 1 enemy alive
  if gameState == "game" and #allies == 0 and usedPieces == maxPieces and #enemies > 0 then
      gameState = "lose"
      return
  end

  -- LOSE CONDITION:
  -- No allies AND usedPieces == maxPieces AND at least 1 enemy alive
  if gameState == "game" and #allies == 0 and usedPieces == maxPieces and #enemies > 0 then
      gameState = "lose"
      return
  end
end

-- Helper funtions
function drawButton(text, x, y, w, h)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("fill", x, y, w, h, 8, 8)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(text, x, y + h/3, w, "center")

    love.graphics.setColor(1, 1, 1)
end

function isInside(x, y, bx, by, bw, bh)
    return x > bx and x < bx + bw and y > by and y < by + bh
end


-- draw function
function love.draw()
    love.graphics.clear(1, 1, 1)

    ---------------------------------------------------
    -- MAIN MENU
    ---------------------------------------------------
    if gameState == "menu" then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("TFT RIPOFF", 0, 100, screenWidth, "center")

        drawButton("Start Game", screenWidth/2 - 100, 250, 200, 60)
        drawButton("Level Select", screenWidth/2 - 100, 350, 200, 60)
        return
    end

    ---------------------------------------------------
    -- LEVEL SELECT
    ---------------------------------------------------
    if gameState == "level_select" then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("Select Level", 0, 50, screenWidth, "center")

        -- Level buttons
        local y = 150
        for i, level in ipairs(levels) do
            drawButton("Level " .. level.id, screenWidth/2 - 100, y, 200, 50)
            y = y + 70
        end

        -- BACK BUTTON
        drawButton("Back", screenWidth/2 - 100, y + 30, 200, 50)
        return
    end

    ---------------------------------------------------
    -- YOU WIN SCREEN
    ---------------------------------------------------
    if gameState == "win" then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("YOU WIN!", 0, 120, screenWidth, "center")

        drawButton("Menu", screenWidth/2 - 100, 250, 200, 60)
        drawButton("Next Level", screenWidth/2 - 100, 330, 200, 60)

        return
    end

    ---------------------------------------------------
    -- YOU LOSE SCREEN
    ---------------------------------------------------
    if gameState == "lose" then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("YOU LOSE!", 0, 120, screenWidth, "center")

        drawButton("Menu", screenWidth/2 - 100, 250, 200, 60)
        drawButton("Try Again", screenWidth/2 - 100, 330, 200, 60)

        return
    end

    ---------------------------------------------------
    -- GAMEPLAY DRAW SECTION
    ---------------------------------------------------
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Mouse: " .. mouseX .. ", " .. mouseY, 10, 10)
    love.graphics.print("Pieces: " .. usedPieces .. " / " .. maxPieces, 10, 30)

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

