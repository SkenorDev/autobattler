require "piece"
function spawnPiece(x,y,team)
     return PieceClass:new(x,y,team)
end

function spawnAlly(x,y)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(allies, spawnPiece(x,y,0))
  hex.occupied=true
  end
end

function spawnEnemy(x,y)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(enemies, spawnPiece(x,y,1))
  hex.occupied=true
  end
  end