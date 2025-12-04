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

-- === GLOBALS FOR GAME FLOW ===
gameState = "menu"

upgradeTokens = 0

rewardGiven = false


pieceLevels = {
    Warrior = 1,
    Archer = 1,
    Tank = 1
}

-- Base stats for each piece
baseStats = {
    Warrior = { hp = 500, atk = 25, range = 1 },
    Archer  = { hp = 350, atk = 30, range = 5 },
    Tank    = { hp = 800, atk = 10, range = 1 },
}

-- Growth multiplier
upgradeMultiplier = 1.15


-- Placement / Battle phases inside the "game" state
placementPhase = true     -- Player placing units / editing
battlePhase = false       -- AI movement + attacks

-- Track shop selection
selectedPieceType = nil

-- Piece selected on board (for move/remove)
selectedPlacedPiece = nil

UI = {
    shopButtonWidth = 100,
    shopButtonHeight = 50,
    shopStatSpacing = 12,   -- vertical spacing between stat lines
}

--Just to place here for now:
function getUpgradedStats(pieceName)
    local level = pieceLevels[pieceName]
    local base = baseStats[pieceName]

    -- scale stats based on 15% increase per level
    local hp = math.floor(base.hp * (upgradeMultiplier ^ (level - 1)))
    local atk = math.floor(base.atk * (upgradeMultiplier ^ (level - 1)))

    return {
        hp = hp,
        atk = atk,
        range = base.range
    }
end


function love.load()
  love.window.setTitle("ARKDIG")
  screenWidth = 600
  screenHeight = 600
  love.window.setMode(screenWidth, screenHeight)
  
  radius = 7
  yGridStart = 55
  yGridEnd = 470
  xGridStart=60
  xGridEnd=560
  
  musicMenu = love.audio.newSource("Assets/music_menu.mp3", "stream")
  musicBattle = love.audio.newSource("Assets/music_battle.mp3", "stream")

  musicMenu:setLooping(true)
  musicBattle:setLooping(true)

  -- Start menu music by default
  love.audio.play(musicMenu)

  
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
  
  
  boardBG = love.graphics.newImage("Assets/BoardBG.png")

  
  --local level = levels[currentLevelIndex]
  --loadLevel(level)

end
local timeAccumulator = 0

function switchMusic(target)
    if target == "menu" then
        if musicBattle:isPlaying() then musicBattle:stop() end
        if not musicMenu:isPlaying() then musicMenu:play() end
    elseif target == "battle" then
        if musicMenu:isPlaying() then musicMenu:stop() end
        if not musicBattle:isPlaying() then musicBattle:play() end
    end
end


function love.update(dt)

  if gameState == "game" and battlePhase == true then
      rewardGiven = false
      timeAccumulator = timeAccumulator + dt
      if timeAccumulator >= 2 then

          -- Run unit updates
          for i, ally in ipairs(allies) do
              ally:update()
          end
          for i, enemy in ipairs(enemies) do
              enemy:update()
          end

          -- Run actions
          for i, ally in ipairs(allies) do
              action(ally)
          end
          for i, enemy in ipairs(enemies) do
              action(enemy)
          end

          -- Death cleanup
          for i = #allies, 1, -1 do
              local ally = allies[i]
              if ally.hp <= 0 then
                  hexGrid[ally.x][ally.y].occupied = false
                  table.remove(allies, i)
              end
          end

          for i = #enemies, 1, -1 do
              local enemy = enemies[i]
              if enemy.hp <= 0 then
                  hexGrid[enemy.x][enemy.y].occupied = false
                  table.remove(enemies, i)
              end
          end

          timeAccumulator = timeAccumulator - 1
      end
      -- MUSIC STATE CONTROL
      if gameState == "game" then
          switchMusic("battle")
      else
          switchMusic("menu")
      end

  end

  -- WIN CONDITION:
  -- No enemies left
  if gameState == "game" and #enemies == 0 then
      if not rewardGiven then
          upgradeTokens = upgradeTokens + 2
          rewardGiven = true
      end
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
function drawButton(text, x, y, w, h, highlight)
    if highlight then
        -- Bright gold highlight
        love.graphics.setColor(1, 0.85, 0)
    else
        -- Normal gray
        love.graphics.setColor(0.8, 0.8, 0.8)
    end

    love.graphics.rectangle("fill", x, y, w, h, 8, 8)

    -- Button outline for clarity
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 8, 8)

    -- Text
    love.graphics.printf(text, x, y + h/3, w, "center")
    love.graphics.setColor(1, 1, 1)
end



function isInside(x, y, bx, by, bw, bh)
    return x > bx and x < bx + bw and y > by and y < by + bh
end


function drawUIBox(x, y, w, h, alpha)
    love.graphics.setColor(1, 1, 1, alpha or 0.8)
    love.graphics.rectangle("fill", x, y, w, h, 6, 6)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 6, 6)

    love.graphics.setColor(1, 1, 1, 1) -- reset color
end



-- draw function
function love.draw()
    love.graphics.clear(1, 1, 1)

    ---------------------------------------------------
    -- MAIN MENU
    ---------------------------------------------------
    if gameState == "menu" then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("ARKDIG", 0, 100, screenWidth, "center")

        drawButton("Start Game", screenWidth/2 - 100, 250, 200, 60)
        drawButton("Level Select", screenWidth/2 - 100, 350, 200, 60)
        drawButton("Upgrades", screenWidth/2 - 100, 450, 200, 60)
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
    -- UPGRADE SCREEN
    ---------------------------------------------------
    if gameState == "upgrade_screen" then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("UPGRADES", 0, 50, screenWidth, "center")

        love.graphics.printf("Tokens: " .. upgradeTokens, 0, 100, screenWidth, "center")

        local x = 100
        local y = 180
        local spacing = 150

        local pieces = {"Warrior", "Archer", "Tank"}

        for i, piece in ipairs(pieces) do
            local level = pieceLevels[piece]
            local current = getUpgradedStats(piece)

            drawButton(piece .. " Lv." .. level, x, y, 200, 60)

            love.graphics.print("HP: " .. current.hp, x + 220, y + 5)
            love.graphics.print("ATK: " .. current.atk, x + 220, y + 25)
            love.graphics.print("RNG: " .. current.range, x + 220, y + 45)

            -- Upgrade button appears if below level 3
            if level < 3 then
                drawButton("Upgrade", x, y + 70, 200, 40)
            end

            y = y + spacing
        end

        drawButton("Back", screenWidth-200, screenHeight - 100, 200, 50)

        return
    end

    ---------------------------------------------------
    -- GAMEPLAY DRAW SECTION
    ---------------------------------------------------
    -- Draw board background
    -- FULLSCREEN BACKGROUND
    love.graphics.setColor(1, 1, 1)
    local bgw = boardBG:getWidth()
    local bgh = boardBG:getHeight()
    local sx = screenWidth / bgw
    local sy = screenHeight / bgh
    love.graphics.draw(boardBG, 0, 0, 0, sx, sy)

    -- READY button appears only during placement
    if gameState == "placement" then
        drawButton("READY", 250, 10, 100, 40)
    end

    local mouseX, mouseY = love.mouse.getPosition()
    -- UI background panel for debug + pieces
    drawUIBox(5, 5, 150, 50, 0.7)
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
    ---------------------------------------------------
    -- SHOP DRAW (buttons + highlight + stats)
    ---------------------------------------------------
    for _, shop in ipairs(shops) do
        local isSelected = (selectedPieceType == shop.name)

        -- Draw shop button with highlight
        drawButton(
            shop.name,
            shop.x,
            shop.y,
            UI.shopButtonWidth,
            UI.shopButtonHeight,
            isSelected
        )

        -- Draw stats (under each button)
        local stats = getUpgradedStats(shop.name)

        if stats then
          -- Background for stats
          drawUIBox(shop.x - 5, shop.y + UI.shopButtonHeight + 2, 110, 70, 0.7)

          love.graphics.setColor(0, 0, 0)
          love.graphics.print("HP:  " .. stats.hp,
              shop.x + 5,
              shop.y + UI.shopButtonHeight + 10
          )
          love.graphics.print("ATK: " .. stats.atk,
              shop.x + 5,
              shop.y + UI.shopButtonHeight + 10 + UI.shopStatSpacing
          )
          love.graphics.print("RNG: " .. stats.range,
              shop.x + 5,
              shop.y + UI.shopButtonHeight + 10 + UI.shopStatSpacing * 2
          )
          love.graphics.setColor(1, 1, 1)

        end
    end



end

