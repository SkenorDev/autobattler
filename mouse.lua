function love.mousepressed(x, y, button)
  
end
local xGridStart = 60
local xGridEnd = 570
local yGridStart = 55
local yGridEnd = 470

local HEX_WIDTH = 60
local HEX_HEIGHT = 70
function love.mousereleased(x, y, button)
  print("Mouse released at:", x, y, "button:", button)
  if button == 1 and y > yGridStart and y < yGridEnd and x > xGridStart and x < xGridEnd then
    -- Convert mouse position relative to grid start
    local relativeX = x - xGridStart
    local relativeY = y - yGridStart
    
    local hexX, hexY = pixelToHex(relativeX, relativeY)
    if hexX>-1 and hexX<8 and hexY>-1 and hexY<8 then
    spawnAlly(hexX,hexY)
    end
    print("Clicked hex coordinates:", hexX, hexY)
  else
    print("Click outside grid area.")
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