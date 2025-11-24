require "piece"
function spawnPiece(x,y,range,attack,hp,team)
     return PieceClass:new(x,y,range,attack,hp,team)
end

function spawnAlly(x,y,range,attack,hp)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(allies, spawnPiece(x,y,range,attack,hp,0))
  hex.occupied=true
  end
end

function spawnEnemy(x,y,range,attack,hp)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(enemies, spawnPiece(x,y,range,attack,hp,1))
  hex.occupied=true
  end
  end