require "hex"

function spawnHex(x,y)
  local dx=0
  local dy=0
  if y % 2 ==1 then
     dx=80+(x*60)
     dy=50+(y*50)
  else
     dx=50+(x*60)
     dy=50+(y*50)
  end
     return HexClass:new(x,y, dx, dy)
end
    
function makeGrid(radius)
   hexGrid = {}
    for x = 0, radius do
      hexGrid[x] = {}
        for y = 0, radius do
            hexGrid[x][y] = spawnHex(x, y)
        end
    end
end

