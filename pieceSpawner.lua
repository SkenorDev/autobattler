require "piece"
function spawnPiece(x,y,range,team)
     return PieceClass:new(x,y,range,team)
end

function spawnAlly(x,y,range)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(allies, spawnPiece(x,y,range,0))
  hex.occupied=true
  end
end

function spawnEnemy(x,y,range)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(enemies, spawnPiece(x,y,range,1))
  hex.occupied=true
  end
  end