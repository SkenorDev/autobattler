function love.mousepressed(x, y, button)
  
end
local xGridStart = 60
local xGridEnd = 570
local yGridStart = 55
local yGridEnd = 470

local HEX_WIDTH = 60
local HEX_HEIGHT = 70

screenWidth = 600
screenHeight = 600



function love.mousereleased(x, y, button)
  -- READY BUTTON CLICK
  if gameState == "placement" and button == 1 then
      if isInside(x, y, 250, 10, 100, 40) then
          gameState = "game"
          battlePhase = true
          timeAccumulator = 0   -- ensures no speed jump
          print(">>> BATTLE STARTED!")
          return
      end
  end

  
  -- MAIN MENU BUTTON LOGIC
  if gameState == "menu" and button == 1 then
      if isInside(x, y, screenWidth/2 - 100, 250, 200, 60) then
          -- Start Game → always Level 1
          currentLevelIndex = 1
          --gameState = "placement"
          loadLevel(levels[currentLevelIndex])
          return
      end

      if isInside(x, y, screenWidth/2 - 100, 350, 200, 60) then
          gameState = "level_select"
          return
      end
      -- Upgrades button
      if isInside(x, y, screenWidth/2 - 100, 450, 200, 60) then
          gameState = "upgrade_screen"
          return
      end

  end

  -- LEVEL SELECT BUTTON LOGIC
  if gameState == "level_select" and button == 1 then
      local yPos = 150
      for i, level in ipairs(levels) do
          if isInside(x, y, screenWidth/2 - 100, yPos, 200, 50) then
              currentLevelIndex = i
              --gameState = "placement"
              loadLevel(level)
              return
          end
          yPos = yPos + 70
      end

      -- BACK BUTTON
      if isInside(x, y, screenWidth/2 - 100, yPos + 30, 200, 50) then
          gameState = "menu"
          return
      end
  end
  
  

  -- WIN SCREEN BUTTONS
  if gameState == "win" and button == 1 then
      -- Menu
      if isInside(x, y, screenWidth/2 - 100, 250, 200, 60) then
          gameState = "menu"
          return
      end

      -- Next Level
      if isInside(x, y, screenWidth/2 - 100, 330, 200, 60) then
          currentLevelIndex = currentLevelIndex + 1

          -- If no more levels exist, wrap to menu
          if not levels[currentLevelIndex] then
              gameState = "menu"
              return
          end

          gameState = "placement"
          loadLevel(levels[currentLevelIndex])
          return
      end
  end

  -- LOSE SCREEN BUTTONS
  if gameState == "lose" and button == 1 then
      -- Menu
      if isInside(x, y, screenWidth/2 - 100, 250, 200, 60) then
          gameState = "menu"
          return
      end

      -- Try Again (reload same level)
      if isInside(x, y, screenWidth/2 - 100, 330, 200, 60) then
          gameState = "placement"
          loadLevel(levels[currentLevelIndex])
          return
      end
  end
  
-- UPGRADE SCREEN CLICKS
if gameState == "upgrade_screen" and button == 1 then
    local pieces = {"Warrior", "Archer", "Tank"}
    local bx = 100      -- button x
    local by = 180      -- starting y
    local spacing = 150

    for _, piece in ipairs(pieces) do
        local level = pieceLevels[piece]

        -- Upgrade button
        local upX = bx
        local upY = by + 70
        local upW = 200
        local upH = 40

        if level < 3 and isInside(x, y, upX, upY, upW, upH) then
            if upgradeTokens >= 1 then
                upgradeTokens = upgradeTokens - 1
                pieceLevels[piece] = pieceLevels[piece] + 1
                print("Upgraded:", piece, "to level", pieceLevels[piece])
            end
        end

        by = by + spacing
    end

    -- BACK BUTTON
    local backX = screenWidth - 200
    local backY = screenHeight - 100

    if isInside(x, y, backX, backY, 200, 50) then
        gameState = "menu"
    end

    return
end



    
  print("Mouse released at:", x, y, "button:", button)
  if button == 2 and y > yGridStart and y < yGridEnd and x > xGridStart and x < xGridEnd then
    -- Convert mouse position relative to grid start
    local relativeX = x - xGridStart
    local relativeY = y - yGridStart
    
    local hexX, hexY = pixelToHex(relativeX, relativeY)
    if hexX>-1 and hexX<8 and hexY>-1 and hexY<8 then
      if holder then
        holder(hexX, hexY,1)
      end
  end
  end
  if button == 1 and y > yGridStart and y < yGridEnd and x > xGridStart and x < xGridEnd then
    -- Convert mouse position relative to grid start
    local relativeX = x - xGridStart
    local relativeY = y - yGridStart
    
    local hexX, hexY = pixelToHex(relativeX, relativeY)
    if hexX>-1 and hexX<8 and hexY>-1 and hexY<8 then
      if holder then
        local hex = hexGrid[hexX][hexY]

            -- ENFORCE PIECE LIMIT
            if usedPieces >= maxPieces then
                print("No more pieces available!")
                return
            end

            -- Only place if unoccupied
            if not hex.occupied then
                holder(hexX, hexY, 0)   -- ally (team = 0)
                usedPieces = usedPieces + 1
                print("Placed ally:", usedPieces, "/", maxPieces)
            else
                print("Hex is occupied.")
            end
      end
    end
    print("Clicked hex coordinates:", hexX, hexY)
  else
    for i, shop in ipairs(shops) do
      if button ==1 and y > shop.y-shop.height and x > shop.x-shop.width then
        print("Clicked shop:", shop.slot)
        holder = shop.piece
        end
      end
  end
end

function pixelToHex(x, y)
    local hexHeight = HEX_HEIGHT
    local hexWidth = HEX_WIDTH
    local hexVert = hexHeight * 3/4  -- vertical spacing between hex centers
    
    local approxY = math.floor(y / hexVert)
    
    local approxX
    if approxY % 2 == 0 then
        approxX = math.floor(x / hexWidth)
    else
        approxX = math.floor((x - (hexWidth / 2)) / hexWidth)
    end

    return approxX, approxY
end